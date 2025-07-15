{{/*
Expand the name of the chart.
*/}}
{{- define "cpnConsole.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "cpnConsole.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/*
Create the name of the service account to use
*/}}
{{- define "cpnConsole.server.serviceAccountName" -}}
{{- if .Values.server.serviceAccount.create }}
{{- default (include "cpnConsole.name" .) .Values.server.serviceAccount.name }}
{{- else }}
{{- default "cpn-server" .Values.server.serviceAccount.name }}
{{- end }}
{{- end }}


{{/*
Create image pull secret
*/}}
{{- define "cpnConsole.imagePullSecret" }}
{{- with .Values.imageCredentials }}
{{- printf "{\"auths\":{\"%s\":{\"username\":\"%s\",\"password\":\"%s\",\"email\":\"%s\",\"auth\":\"%s\"}}}" .registry .username .password .email (printf "%s:%s" .username .password | b64enc) | b64enc }}
{{- end }}
{{- end }}

{{/*
Create postgresql DB url connexion
*/}}
{{- define "cpnConsole.dbUrlValue" }}
{{- if .Values.global.postgresql.dbUrl }}
{{- .Values.global.postgresql.dbUrl }}
{{- else }}
{{- printf "postgresql://%s:%s@%s-%s-hl:%s/%s?schema=public" .Values.postgresql.auth.username .Values.postgresql.auth.password .Release.Name .Values.postgresql.nameOverride (.Values.postgresql.primary.service.ports.postgresql | toString) .Values.postgresql.auth.database }}
{{- end }}
{{- end }}


{{/*
Create container environment variables from configmap
*/}}
{{- define "cpnConsole.env" -}}
{{ range $key, $val := .env }}
{{ $key }}: {{ $val | quote }}
{{- end }}
{{- end }}


{{/*
Create container environment variables from secret
*/}}
{{- define "cpnConsole.secret" -}}
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
{{- define "cpnConsole.fullname" -}}
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
{{- define "cpnConsole.common.labels" -}}
helm.sh/chart: {{ include "cpnConsole.chart" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "cpnConsole.client.labels" -}}
{{ include "cpnConsole.common.labels" . }}
{{ include "cpnConsole.client.selectorLabels" . }}
{{- end }}

{{- define "cpnConsole.server.labels" -}}
{{ include "cpnConsole.common.labels" . }}
{{ include "cpnConsole.server.selectorLabels" . }}
{{- end }}


{{/*
Selector labels
*/}}
{{- define "cpnConsole.client.selectorLabels" -}}
app.kubernetes.io/name: {{ include "cpnConsole.name" . }}-client
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "cpnConsole.server.selectorLabels" -}}
app.kubernetes.io/name: {{ include "cpnConsole.name" . }}-server
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
