{/*
Generate Pre Defined Rollout Strategy
You can add another strategy by adding another if block
*/}}
{{- define "preDefinedStrategy" -}}
{{- if (eq "manual-canary-1-pod" .Values.rollout.preDefinedStrategy) -}}
canary:
  maxSurge: 0
  maxUnavailable: 1
  stableMetadata:
    labels:
      role: "stable"
      canary: "false"
  canaryMetadata:
    labels:
      role: "canary"
      canary: "true"
  steps:
  - setWeight: 1
  - pause: { }
{{- else if (eq "manual-canary-20-pct" .Values.rollout.preDefinedStrategy) -}}
canary:
  stableMetadata:
    labels:
      role: "stable"
      canary: "false"
  canaryMetadata:
    labels:
      role: "canary"
      canary: "true"
  steps:
  - setWeight: 20
  - pause: { }
{{- else }}
    {{- fail "value for .Values.rollout.preDefinedStrategy is not listed as a preDefinedStrategy list" }}
{{- end -}}
{{- end -}}


{/*
Generate Deployment Strategy block
*/}}
{{- define "DeploymentStrategy" -}}
{{- if and (.Values.rollout.strategy) (.Values.rollout.preDefinedStrategy) }}
    {{- fail "Rollout strategy must be either preDefinedStrategy OR Manual strategy (rollout.strategy)" }}
  {{- else if and (.Values.rollout.strategy) (eq .Values.rollout.preDefinedStrategy "") }}
    {{- toYaml .Values.rollout.strategy | nindent 4 -}}
  {{- else if and (not .Values.rollout.strategy) (.Values.rollout.preDefinedStrategy) }}
    {{- include "preDefinedStrategy" . | nindent 4 }}
{{- end }}
{{- end }}
