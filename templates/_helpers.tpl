{/* vim: set filetype=mustache: */}}

{{/*
Expand the name of the chart.
*/}}
{{- define "mayan.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "mayan.fullname" -}}
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
{{- define "mayan.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "mayan.labels" -}}
helm.sh/chart: {{ include "mayan.chart" . }}
{{ include "mayan.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "mayan.selectorLabels" -}}
app.kubernetes.io/name: {{ include "mayan.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "mayan.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "mayan.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}


{{/* === Custom helpers === */}}

{{/*
Selector labels with name suffix
*/}}
{{- define "mayan.selectorLabelsWithSuffix" -}}
app.kubernetes.io/name: {{ include "mayan.name" .root }}-{{- printf "%s" .nameSuffix -}}
{{ printf "\n" }}app.kubernetes.io/instance: {{- printf " %s" .root.Release.Name -}}
{{- end }}

{{- define "mayan.secretsName" -}}
{{- $name := "mayan-edms" }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}-secrets
{{- end }}
{{- end }}

{{- define "mayan.configMapName" -}}
{{- $name := "mayan-edms" }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}-configmap
{{- end }}
{{- end }}

{{- define "mayan.postgresql.fullname" -}}
{{- if .Values.postgresql.fullnameOverride -}}
{{- .Values.postgresql.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default "postgresql" .Values.postgresql.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Generate the MAYAN_DATABASES environment variable
*/}}
{{- define "mayan.secrets.databases" -}}
{'default':{'ENGINE':'django.db.backends.postgresql','NAME':'{{ .Values.postgresql.postgresqlDatabase }}','PASSWORD':'{{ .Values.postgresql.postgresqlPassword }}','USER':'{{ .Values.postgresql.postgresqlUsername }}','HOST':'{{ template "mayan.postgresql.fullname" . }}'}}
{{- end -}}

{{/*
Generate the RabbitMQ hostname
*/}}
{{- define "mayan.rabbitmq.host" -}}
{{ .Release.Name }}-rabbitmq
{{- end -}}

{{/*
Generate the MAYAN_CELERY_BROKEN_URL environment variable
*/}}
{{- define "mayan.secrets.celeryBrokerUrl" -}}
amqp://{{ .Values.rabbitmq.rabbitmq.username }}:{{ .Values.rabbitmq.rabbitmq.password }}@{{ template "mayan.rabbitmq.host" . }}:{{ .Values.rabbitmq.service.port }}
{{- end -}}

{{/*
Generate the Redis hostname
*/}}
{{- define "mayan.redis.host" -}}
{{ .Release.Name }}-redis-master
{{- end -}}

{{/*
Generate the MAYAN_CELERY_RESULT_BACKEND environment variable
*/}}
{{- define "mayan.secrets.celeryResultBackend" -}}
redis://:{{ .Values.redis.password }}@{{ template "mayan.redis.host" . }}:{{ .Values.redis.redisPort }}/0
{{- end -}}

{{/*
Generate the MAYAN_LOCK_MANAGER_BACKEND_ARGUMENTS environment variable
*/}}
{{- define "mayan.secrets.lockManagerBackendArguments" -}}
{'redis_url': 'redis://:{{ .Values.redis.password }}@{{ template "mayan.redis.host" . }}:{{ .Values.redis.redisPort }}/1'}
{{- end -}}

{{- define "mayan.persistentVolumeClaimName" -}}
{{- printf "%s-%s" .Release.Name "mayan-media" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "mayan.persistentVolumeName" -}}
{{- printf "%s-%s" .Release.Name "mayan-media" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "mayan.persistentVolumePath" -}}
{{- printf "/%s/%s/%s" "data" "mayan-media" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

