{{/*
Expand the name of the chart.
*/}}
{{- define "cpnAnsibleJob.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "cpnAnsibleJob.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "cpnAnsibleJob.fullname" -}}
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
{{- define "cpnAnsibleJob.job.serviceAccountName" -}}
{{- default (include "cpnAnsibleJob.name" .) .Values.job.serviceAccount.name }}
{{- end }}


{{/*
Generate the common job pod spec used in both Job and CronJob templates.
*/}}
{{- define "cpnAnsibleJob.jobPodSpec" -}}
spec:
  template:
    metadata:
      labels:
        {{- include "cpnAnsibleJob.job.selectorLabels" . | nindent 8 }}
        {{- with .Values.job.podLabels }}
        {{- toYaml . | nindent 8 }}
        {{- end }}
    spec:
      serviceAccountName: {{ include "cpnAnsibleJob.job.serviceAccountName" . | default .Values.job.serviceAccount.name}}
      restartPolicy: {{ .Values.job.restartPolicy }}
      containers:
        - name: {{ .playbookName }}-post-conf
          image: {{ .Values.job.image.repository }}:{{ .Values.job.image.tag | default .Chart.AppVersion }}
          command:
            - /bin/sh
            - -c
            - |
              git clone https://github.com/cloud-pi-native/socle.git && \
              cd socle && \
              ansible-playbook post-install/{{ .playbookName }}.yaml
          {{- include "cpnAnsibleJob.fullSecurityContext" . | indent 10 }}
          {{- with .Values.job.extraEnv }}
          env:
            {{- toYaml . | nindent 12 }}
          {{- end }}
{{- end }}


{{/*
Add securityContext depending on platform.
*/}}
{{- define "cpnAnsibleJob.fullSecurityContext" -}}
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
{{- define "cpnAnsibleJob.common.labels" -}}
helm.sh/chart: {{ include "cpnAnsibleJob.chart" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "cpnAnsibleJob.job.labels" -}}
{{ include "cpnAnsibleJob.common.labels" . }}
{{ include "cpnAnsibleJob.job.selectorLabels" . }}
{{- end }}


{{/*
Selector labels
*/}}
{{- define "cpnAnsibleJob.job.selectorLabels" -}}
app.kubernetes.io/name: {{ include "cpnAnsibleJob.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
