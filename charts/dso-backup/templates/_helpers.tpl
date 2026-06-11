{{/*
Expand the name of the chart.
*/}}
{{- define "dso-backup.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "dso-backup.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "dso-backup.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/*
Common labels
*/}}
{{- define "dso-backup.labels" -}}
helm.sh/chart: {{ include "dso-backup.chart" . }}
{{ include "dso-backup.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "dso-backup.selectorLabels" -}}
app.kubernetes.io/name: {{ include "dso-backup.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "dso-backup.serviceAccountName" -}}
{{- if .Values.rbac.create }}
{{- default (printf "%s-backup-sa" .Values.global.appName) .Values.rbac.serviceAccountName }}
{{- else }}
{{- default "default" .Values.rbac.serviceAccountName }}
{{- end }}
{{- end }}

{{/*
Get the namespace
*/}}
{{- define "dso-backup.namespace" -}}
{{- default .Release.Namespace .Values.global.namespace }}
{{- end }}

{{/*
Get the app name
*/}}
{{- define "dso-backup.appName" -}}
{{- required "global.appName is required" .Values.global.appName }}
{{- end }}

{{/*
Check if CNPG strategy is enabled
*/}}
{{- define "dso-backup.isCNPG" -}}
{{- eq .Values.strategy "cnpg" }}
{{- end }}

{{/*
Check if resources-only strategy is enabled
*/}}
{{- define "dso-backup.isResourcesOnly" -}}
{{- eq .Values.strategy "resources-only" }}
{{- end }}

{{/*
Check if vault strategy is enabled
*/}}
{{- define "dso-backup.isVault" -}}
{{- eq .Values.strategy "vault" }}
{{- end }}

{{/*
Check if a backup CronJob should be rendered.
The chart currently renders a CronJob for strategies that need orchestration.
*/}}
{{- define "dso-backup.cronjobEnabled" -}}
{{- or (eq .Values.strategy "cnpg") (eq .Values.strategy "vault") }}
{{- end }}

{{/*
Resolve the image used by the backup CronJob.
For the vault strategy, vault.image overrides schedule.image because the
default schedule image (bitnami/kubectl) lacks aws-cli.
*/}}
{{- define "dso-backup.image" -}}
{{- if eq .Values.strategy "vault" -}}
{{ .Values.vault.image.repository }}:{{ .Values.vault.image.tag }}
{{- else -}}
{{ .Values.schedule.image.repository }}:{{ .Values.schedule.image.tag }}
{{- end -}}
{{- end }}

{{- define "dso-backup.imagePullPolicy" -}}
{{- if eq .Values.strategy "vault" -}}
{{ .Values.vault.image.pullPolicy }}
{{- else -}}
{{ .Values.schedule.image.pullPolicy }}
{{- end -}}
{{- end }}

{{/*
Render the Vault pod label selector as a comma-separated list (kubectl -l form).
*/}}
{{- define "dso-backup.vaultLabelSelector" -}}
{{- $parts := list -}}
{{- range $k, $v := .Values.vault.podLabelSelector -}}
{{- $parts = append $parts (printf "%s=%s" $k $v) -}}
{{- end -}}
{{- join "," $parts -}}
{{- end }}

{{/*
Get CNPG cluster name
*/}}
{{- define "dso-backup.cnpgClusterName" -}}
{{- if .Values.cnpg.clusterName }}
{{- .Values.cnpg.clusterName }}
{{- else }}
{{- printf "pg-cluster-%s" .Values.global.appName }}
{{- end }}
{{- end }}

{{/*
Generate excluded resources list
*/}}
{{- define "dso-backup.excludedResources" -}}
{{- if eq .Values.strategy "cnpg" }}
{{- $defaultExcludes := list "pods" "jobs" "backups.postgresql.cnpg.io" }}
{{- $userExcludes := .Values.velero.resources.exclude | default list }}
{{- $allExcludes := concat $defaultExcludes $userExcludes | uniq }}
{{- toYaml $allExcludes }}
{{- else }}
{{- toYaml .Values.velero.resources.exclude }}
{{- end }}
{{- end }}

{{/*
Generate label selector for CNPG strategy
Excludes resources managed by CloudNativePG operator (PVCs, Jobs, Poolers)
but includes Cluster CR and application resources
*/}}
{{- define "dso-backup.cnpgLabelSelector" -}}
{{- if and (eq .Values.strategy "cnpg") (not .Values.velero.resources.labelSelector) }}
matchExpressions:
- key: app.kubernetes.io/managed-by
  operator: NotIn
  values: ["cloudnative-pg"]
{{- end }}
{{- end }}
