{{/*
Expand the name of the chart.
*/}}
{{- define "cpnOpenCDSMockoon.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "cpnOpenCDSMockoon.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/*
Create image pull secret
*/}}
{{- define "cpnOpenCDSMockoon.imagePullSecret" }}
{{- with .Values.imageCredentials }}
{{- printf "{\"auths\":{\"%s\":{\"username\":\"%s\",\"password\":\"%s\",\"email\":\"%s\",\"auth\":\"%s\"}}}" .registry .username .password .email (printf "%s:%s" .username .password | b64enc) | b64enc }}
{{- end }}
{{- end }}


{{/*
Create container environment variables from configmap
*/}}
{{- define "cpnOpenCDSMockoon.env" -}}
{{ range $key, $val := .env }}
{{ $key }}: {{ $val | quote }}
{{- end }}
{{- end }}


{{/*
Create container environment variables from secret
*/}}
{{- define "cpnOpenCDSMockoon.secret" -}}
{{ range $key, $val := .secrets }}
{{ $key }}: {{ $val | b64enc | quote }}
{{- end }}
{{- end }}


{{/*
Define a file checksum to trigger rollout on configmap of secret change
*/}}
{{- define "checksum" -}}
{{- $ := index . 0 }}
{{- $path := index . 1 }}
{{- $resourceType := include (print $.Template.BasePath $path) $ | fromYaml -}}
{{- if $resourceType -}}
checksum/{{ $resourceType.metadata.name }}: {{ $resourceType.data | toYaml | sha256sum }}
{{- end -}}
{{- end -}}


{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "cpnOpenCDSMockoon.fullname" -}}
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
Common labels
*/}}
{{- define "cpnOpenCDSMockoon.common.labels" -}}
helm.sh/chart: {{ include "cpnOpenCDSMockoon.chart" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "cpnOpenCDSMockoon.opencds.labels" -}}
{{ include "cpnOpenCDSMockoon.common.labels" . }}
{{ include "cpnOpenCDSMockoon.opencds.selectorLabels" . }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "cpnOpenCDSMockoon.opencds.selectorLabels" -}}
app.kubernetes.io/name: {{ include "cpnOpenCDSMockoon.name" . }}-backend
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
