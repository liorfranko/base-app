# base-app

Helm Chart with Canary deployment using Argo Rollouts and revisioned configmaps.

![Version: 1.0.0](https://img.shields.io/badge/Version-1.0.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

## Additional Information
This chart provide the ability to perform Canary deployments using Argo Rollouts with the configmaps revisions.

**It runs on 5 basis:**
1. A Rollout object is in use instaed of a deployment. (So you must have Argo Rollouts controller deployed on the cluster)
2. A `checksum/config` annotation is added to the Rollout to trigger a rollout based on a configmap change for [for more information click here](https://helm.sh/docs/howto/charts_tips_and_tricks/#automatically-roll-deployments).
3. The configmap name ends with hashed suffix.
4. On every deploy a Job run to attach the configmaps to the ReplicaSet's, using ownerRefrence [for more information click here](https://kubernetes.io/docs/concepts/overview/working-with-objects/owners-dependents/).
5. By default, the configmaps are mounted on the pods to `/etc/kubernetes/configmaps`, that can be modified using `configmapsMountPath`

**Behaviour:**
1. Every change in the configmaps values will trigger a creation of a new configmap, while the old one won't be replaced.
2. The new configmap will be attached to the new ReplicaSet.
3. The old configmaps will be deleted with the old ReplicaSets by K8S garbege collector.

## Prerequsets
* You must have Argo Rollouts controller deployed.
* You must deploy this chart with ArgoCD.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| appName | string | `"test-service"` | (REQUIRED) Application name which will be used by all resources created via base chart. Also will be available via APPNAME variable inside pods |
| configmapAttacher | object | `{"repository":"quay.io/liorfranko/configmap-attacher","resources":{"limits":{"cpu":0.1,"memory":"100Mi"},"requests":{"cpu":0.1,"memory":"100Mi"}},"tag":"1.0.1"}` | Variables of the configmap-attacher |
| configmaps.example-cm-1.kv_data.key-1 | string | `"value-13"` |  |
| configmaps.example-cm-1.kv_data.key-2 | string | `"value-2"` |  |
| configmaps.example-cm-1.raw_data.somename | string | `"line 1\nline 2\n"` |  |
| configmaps.example-cm-2.kv_data.key-3 | string | `"value-3"` |  |
| configmaps.example-cm-2.kv_data.key-4 | string | `"value-4"` |  |
| configmaps.example-cm-2.raw_data.somename | string | `"line 1\nline 2\n"` |  |
| configmapsMountPath | string | `"/etc/kubernetes/configmaps"` | Allows to define custom configMap objects with custom content |
| image.imagePullPolicy | string | `"Always"` | ImagePullPolicy applied to application |
| image.repository | string | `"nginx"` | Repository applied to application |
| image.tag | string | `"1.14.3"` | Tag applied to application |
| rbac.enabled | bool | `false` |  |
| replicas | int | `1` | The number of application pods to run |
| rollout.preDefinedStrategy | string | `"manual-canary-1-pod"` |  |
| rollout.strategy | object | `{}` | Use custom strategy of the argo rollout |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.5.0](https://github.com/norwoodj/helm-docs/releases/v1.5.0)
