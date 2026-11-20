groups:
  - name: DSO_Backup
    rules:
      # Alert names deliberately avoid the patterns targeted by the Alertmanager inhibit rules
      # (".+ not available", ".+ Pod not healthy", "CNPGCluster.+"): backup failures must never be hidden.
      # Severity is critical so that backup failures are never dropped by warning-level routing.
      # vault-backup-cronjob (Velero) is excluded because its backups report a partial failure;
      # the Vault data itself is covered by the backup-utils-vault CronJob.
      - alert: Backup Job failed
        annotations:
          message: Backup Job {{`{{`}} $labels.job_name {{`}}`}} of CronJob {{`{{`}} $labels.owner_name {{`}}`}} failed in namespace {{`{{`}} $labels.namespace {{`}}`}} (cluster {{`{{`}} $labels.cluster {{`}}`}}) and no later run has succeeded yet.
          summary: Backup Job failed for {{`{{`}} $labels.owner_name {{`}}`}}
        expr: |
          ((kube_job_status_start_time
          * on(namespace, job_name, cluster) group_left(owner_name)
          kube_job_owner{
          owner_kind="CronJob",
          owner_name=~".*backup.*",
          owner_name!="vault-backup-cronjob",
          namespace=~"{{ .Values.app.namespacePrefix }}.+"})
          and on(namespace, job_name, cluster)
          (kube_job_failed{condition="true"} == 1))
          > on(namespace, owner_name, cluster) group_left()
          label_replace(kube_cronjob_status_last_successful_time, "owner_name", "$1", "cronjob", "(.*)")
        for: 1m
        labels:
          severity: critical
      - alert: Backup CronJob outdated
        annotations:
          message: CronJob {{`{{`}} $labels.cronjob {{`}}`}} in namespace {{`{{`}} $labels.namespace {{`}}`}} (cluster {{`{{`}} $labels.cluster {{`}}`}}) has not completed a backup for more than 27 hours (daily schedule). VALUE = {{`{{`}} $value | humanizeDuration {{`}}`}}
          summary: No successful backup for {{`{{`}} $labels.cronjob {{`}}`}} in the last 27 hours
        expr: |
          time() - kube_cronjob_status_last_successful_time{
          cronjob=~".*backup.*",
          cronjob!~"vault-backup-cronjob|gitlab-toolbox-backup|.*backup-utils-vault",
          namespace=~"{{ .Values.app.namespacePrefix }}.+"} > 27 * 3600
        for: 15m
        labels:
          severity: critical
      - alert: Backup frequent CronJob outdated
        annotations:
          message: CronJob {{`{{`}} $labels.cronjob {{`}}`}} in namespace {{`{{`}} $labels.namespace {{`}}`}} (cluster {{`{{`}} $labels.cluster {{`}}`}}) has not completed a backup for more than 13 hours (6-hour schedule). VALUE = {{`{{`}} $value | humanizeDuration {{`}}`}}
          summary: No successful backup for {{`{{`}} $labels.cronjob {{`}}`}} in the last 13 hours
        expr: |
          time() - kube_cronjob_status_last_successful_time{
          cronjob=~"gitlab-toolbox-backup|.*backup-utils-vault",
          namespace=~"{{ .Values.app.namespacePrefix }}.+"} > 13 * 3600
        for: 15m
        labels:
          severity: critical
      # CNPG exposes the last backup timestamp only on the instance that ran it (0 elsewhere):
      # aggregate per namespace and keep the maximum seen over one day so that a failover does not
      # reset the value. ScheduledBackups run every 6 hours.
      - alert: CNPG backup outdated
        annotations:
          message: No CNPG backup completed for more than 13 hours in namespace {{`{{`}} $labels.namespace {{`}}`}} (cluster {{`{{`}} $labels.cluster {{`}}`}}). A Backup stuck in a non-terminal phase (for example walArchivingFailing) blocks the following ones. Check the Backup resources of the namespace.
          summary: No CNPG backup completed for more than 13 hours in {{`{{`}} $labels.namespace {{`}}`}} (check for a Backup stuck in a non-terminal phase)
        expr: |
          time() - max_over_time(
          max by (cluster, namespace) (cnpg_collector_last_available_backup_timestamp{
          namespace=~"{{ .Values.app.namespacePrefix }}.+"})[1d:5m]) > 13 * 3600
        for: 15m
        labels:
          severity: critical
      - alert: CNPG backup failed
        annotations:
          message: The last CNPG backup failed in namespace {{`{{`}} $labels.namespace {{`}}`}} (cluster {{`{{`}} $labels.cluster {{`}}`}}) and no backup has succeeded since.
          summary: CNPG backup failed in {{`{{`}} $labels.namespace {{`}}`}}
        expr: |
          max by (cluster, namespace) (cnpg_collector_last_failed_backup_timestamp{
          namespace=~"{{ .Values.app.namespacePrefix }}.+"})
          > max by (cluster, namespace) (cnpg_collector_last_available_backup_timestamp{
          namespace=~"{{ .Values.app.namespacePrefix }}.+"})
        for: 5m
        labels:
          severity: critical
      - alert: CNPG WAL archiving failing
        annotations:
          message: PostgreSQL WAL archiving is failing for {{`{{`}} $labels.pod {{`}}`}} in namespace {{`{{`}} $labels.namespace {{`}}`}} (cluster {{`{{`}} $labels.cluster {{`}}`}}). Backups and point-in-time recovery are at risk.
          summary: CNPG WAL archiving failing in {{`{{`}} $labels.namespace {{`}}`}}
        expr: |
          increase(cnpg_pg_stat_archiver_failed_count{
          namespace=~"{{ .Values.app.namespacePrefix }}.+"}[5m]) > 0
        for: 10m
        labels:
          severity: critical
      - alert: Velero backup failed
        annotations:
          message: A Velero backup failed during the last hour (cluster {{`{{`}} $labels.cluster {{`}}`}}). Check the Backup resources in namespace {{`{{`}} $labels.namespace {{`}}`}}.
          summary: Velero backup failed
        expr: |
          increase(velero_backup_failure_total{
          namespace="{{ .Values.app.namespacePrefix }}backup"}[1h]) > 0
        for: 1m
        labels:
          severity: critical
