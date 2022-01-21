{{/* vim: set filetype=mustache: */}}

{{/*
Expand the name of the release
*/}}
{{- define "name" -}}
{{- required "Please specify an app_name at .Values.appName" .Values.appName -}}
{{- end -}}

{/*
Generate configmaps volume
*/}}
{{- define "configmapsVolume" -}}
{{- $appname := (include "name" .) -}}
{{- $root := . }}
- name: "configmaps-volume"
  projected:
    sources:
    {{- range $key, $value := .Values.configmaps }}
      - configMap:
        {{- if $root.Values.rollout.enabled }}
          name: "{{ $appname }}-{{ $key }}-{{ $value | toString | adler32sum }}"
        {{- else }}
          name: "{{ $appname }}-{{ $key }}"
        {{- end }}
    {{- end }}
{{- end }}


{/*
Generate configmaps volumeMount section
*/}}
{{- define "configmapVolumeMount" -}}
- name: "configmaps-volume"
  mountPath: {{ .Values.configmapsMountPath }}
{{- end }}

{/*
Generate configmaps list
*/}}
{{- define "configmapList" -}}
{{- $appname := (include "name" .) -}}
{{- $out := "" -}}
{{- range $key, $value := .Values.configmaps }}
{{- $out = printf "%s,%s-%s-%s" ($out) ($appname) ($key) ($value | toString | adler32sum) }}
{{- end }}
{{- trimPrefix "," $out }}
{{- end }}
