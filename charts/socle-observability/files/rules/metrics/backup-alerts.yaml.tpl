groups:
  - name: DSO_Backups
    rules:
      - alert: DSO backup CronJob not succeeding
        annotations:
          message: CronJob {{`{{`}} $labels.cronjob {{`}}`}} in namespace {{`{{`}} $labels.namespace {{`}}`}} (cluster {{`{{`}} $labels.ocp_cluster {{`}}`}}) has had no successful run for more than 26 hours, or has never succeeded.
          summary: Backup CronJob {{`{{`}} $labels.cronjob {{`}}`}} not succeeding
        expr: |
          (
            (
              time() - max by (ocp_cluster, namespace, cronjob) (kube_cronjob_status_last_successful_time{
              cronjob=~".*backup.*",
              namespace=~"{{ .Values.app.namespacePrefix }}.*"}) > 93600
            )
            or
            (
              max by (ocp_cluster, namespace, cronjob) (kube_cronjob_created{
              cronjob=~".*backup.*",
              namespace=~"{{ .Values.app.namespacePrefix }}.*"}) < time() - 93600
              unless on (ocp_cluster, namespace, cronjob) kube_cronjob_status_last_successful_time
            )
          )
          unless on (ocp_cluster, namespace, cronjob) (kube_cronjob_spec_suspend == 1)
        for: 30m
        labels:
          severity: critical
      - alert: DSO backup Job stuck
        annotations:
          message: Backup Job {{`{{`}} $labels.job_name {{`}}`}} in namespace {{`{{`}} $labels.namespace {{`}}`}} (cluster {{`{{`}} $labels.ocp_cluster {{`}}`}}) has been running for more than 6 hours. With concurrencyPolicy Forbid, it blocks the next runs.
          summary: Backup Job {{`{{`}} $labels.job_name {{`}}`}} stuck
        expr: |
          (
            time() - max by (ocp_cluster, namespace, job_name) (kube_job_status_start_time{
            job_name=~".*backup.*",
            namespace=~"{{ .Values.app.namespacePrefix }}.*"}) > 21600
          )
          and on (ocp_cluster, namespace, job_name)
          (
            max by (ocp_cluster, namespace, job_name) (kube_job_status_active{
            job_name=~".*backup.*",
            namespace=~"{{ .Values.app.namespacePrefix }}.*"}) > 0
          )
        for: 15m
        labels:
          severity: warning
      - alert: DSO CNPG backup too old
        annotations:
          message: The last available backup of the CNPG cluster in namespace {{`{{`}} $labels.namespace {{`}}`}} (cluster {{`{{`}} $labels.ocp_cluster {{`}}`}}) is older than 26 hours, or no backup exists.
          summary: CNPG backup too old in namespace {{`{{`}} $labels.namespace {{`}}`}}
        expr: |
          time() - max by (ocp_cluster, namespace) (cnpg_collector_last_available_backup_timestamp{
          namespace=~"{{ .Values.app.namespacePrefix }}.*"}) > 93600
        for: 30m
        labels:
          severity: critical
      - alert: DSO CNPG last backup failed
        annotations:
          message: The last backup attempt of the CNPG cluster in namespace {{`{{`}} $labels.namespace {{`}}`}} (cluster {{`{{`}} $labels.ocp_cluster {{`}}`}}) failed.
          summary: CNPG backup failed in namespace {{`{{`}} $labels.namespace {{`}}`}}
        expr: |
          max by (ocp_cluster, namespace) (cnpg_collector_last_failed_backup_timestamp{
          namespace=~"{{ .Values.app.namespacePrefix }}.*"})
          > max by (ocp_cluster, namespace) (cnpg_collector_last_available_backup_timestamp{
          namespace=~"{{ .Values.app.namespacePrefix }}.*"})
        for: 5m
        labels:
          severity: warning
