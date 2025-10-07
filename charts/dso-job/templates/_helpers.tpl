{{/*
Expand the name of the chart.
*/}}
{{- define "cpnJob.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "cpnJob.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "cpnJob.fullname" -}}
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
Create the name of the service account to use
*/}}
{{- define "cpnJob.job.serviceAccountName" -}}
{{- default (include "cpnJob.name" .) .Values.job.serviceAccount.name }}
{{- end }}


{{/*
Generate the common job pod spec used in both Job and CronJob templates.
This helper accepts an optional dict to override parts of the pod spec,
such as the command.
Usage:
  {{ include "cpnJob.jobPodSpec" (dict "Values" .Values "Chart" .Chart "command" .Values.cronJob.command) }}
*/}}
{{- define "cpnJob.jobPodSpec" -}}
spec:
  {{- if .Values.job.activeDeadlineSeconds }}
  activeDeadlineSeconds: {{ .Values.job.activeDeadlineSeconds }}
  {{- end }}
  backoffLimit: {{ .Values.job.backoffLimit }}
  template:
    metadata:
      labels:
        {{- include "cpnJob.job.selectorLabels" . | nindent 8 }}
        {{- with .Values.job.podLabels }}
        {{- toYaml . | nindent 8 }}
        {{- end }}
    spec:
      serviceAccountName: {{ include "cpnJob.job.serviceAccountName" . | default .Values.job.serviceAccount.name }}
      restartPolicy: {{ .Values.job.restartPolicy }}
      containers:
        - name: dso-job
          image: {{ .Values.job.image.repository }}:{{ .Values.job.image.tag | default .Chart.AppVersion }}
          imagePullPolicy: {{ .Values.job.image.pullPolicy }}
          {{- with .command | default .Values.job.command }}
          command:
            {{- toYaml . | nindent 12 }}
          {{- end }}
          {{- include "cpnJob.fullSecurityContext" . | indent 10 }}
          {{- with .Values.job.extraEnv }}
          env:
            {{- toYaml . | nindent 12 }}
          {{- end }}
          {{- with .Values.job.extraEnvFrom }}
          envFrom:
            {{- toYaml . | nindent 12 }}
          {{- end }}
          {{- with .Values.job.extraVolumeMounts }}
          volumeMounts:
            {{- toYaml . | nindent 12 }}
          {{- end }}
      {{- with .Values.job.extraVolumes }}
      volumes:
        {{- toYaml . | nindent 8 }}
      {{- end }}
{{- end }}


{{/*
Add securityContext depending on platform.
*/}}
{{- define "cpnJob.fullSecurityContext" -}}
{{- if eq .Values.global.platform "kubernetes" }}
securityContext:
  allowPrivilegeEscalation: false
  capabilities:
    drop:
      - ALL
  runAsNonRoot: true
  runAsUser: 1000
  runAsGroup: 1000
  seccompProfile:
    type: RuntimeDefault
{{- end }}
{{- end }}


{{/*
Common labels
*/}}
{{- define "cpnJob.common.labels" -}}
helm.sh/chart: {{ include "cpnJob.chart" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "cpnJob.job.labels" -}}
{{ include "cpnJob.common.labels" . }}
{{ include "cpnJob.job.selectorLabels" . }}
{{- end }}


{{/*
Selector labels
*/}}
{{- define "cpnJob.job.selectorLabels" -}}
app.kubernetes.io/name: {{ include "cpnJob.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
