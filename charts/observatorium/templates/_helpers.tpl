{{/*
Expand the name of the chart.
*/}}
{{- define "observatorium.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "observatorium.fullname" -}}
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
{{- define "observatorium.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "observatorium.resourceName" -}}
{{- $resourceName := include "observatorium.fullname" .ctx -}}
{{- if .component -}}{{- $resourceName = printf "%s-%s" $resourceName .component -}}{{- end -}}
{{- if gt (len $resourceName) 253 -}}{{- printf "Resource name (%s) exceeds kubernetes limit of 253 character. To fix: shorten release name if this will be a fresh install or shorten zone names (e.g. \"a\" instead of \"zone-a\") if using zone-awareness." $resourceName | fail -}}{{- end -}}
{{- $resourceName -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "observatorium.labels" -}}
helm.sh/chart: {{ include "observatorium.chart" .ctx }}
app.kubernetes.io/name: {{ include "observatorium.name" .ctx }}
app.kubernetes.io/instance: {{ .ctx.Release.Name }}
{{- if .component }}
app.kubernetes.io/component: {{ .component }}
{{- end }}
{{- if .ctx.Chart.AppVersion }}
app.kubernetes.io/version: {{ .ctx.Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .ctx.Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "observatorium.selectorLabels" -}}
app.kubernetes.io/name: {{ include "observatorium.name" .ctx }}
app.kubernetes.io/instance: {{ .ctx.Release.Name }}
{{- if .component }}
app.kubernetes.io/component: {{ .component }}
{{- end }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "observatorium.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "observatorium.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "observatorium.componentSectionFromName" -}}
{{- $componentsMap := dict
  "api" "api"
  "rate-limiter" "gubernator"
-}}
{{- $componentSection := index $componentsMap .component -}}
{{- if not $componentSection -}}{{- printf "No component section mapping for %s not found in values; submit a bug report if you are a user, edit observatorium.componentSectionFromName if you are a contributor" .component | fail -}}{{- end -}}
{{- $section := .ctx.Values -}}
{{- range regexSplit "\\." $componentSection -1 -}}
  {{- $section = index $section . -}}
  {{- if not $section -}}{{- printf "Component section %s not found in values; values: %s" . ($.ctx.Values | toJson | abbrev 100) | fail -}}{{- end -}}
{{- end -}}
{{- $section | toYaml -}}
{{- end -}}

{{- define "observatorium.config.checksum" -}}
checksum/config: {{ include (print .Template.BasePath "/api-configmap.yaml") . | sha256sum }}
{{- end -}}