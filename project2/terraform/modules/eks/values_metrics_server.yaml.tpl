rbac:
  # Specifies whether RBAC resources should be created
  create: true
  pspEnabled: false

serviceAccount:
  # Specifies whether a ServiceAccount should be created
  create: true
  # The name of the ServiceAccount to use.
  # If not set and create is true, a name is generated using the fullname template
  name:

apiService:
  # Specifies if the v1beta1.metrics.k8s.io API service should be created.
  #
  # You typically want this enabled! If you disable API service creation you have to
  # manage it outside of this chart for e.g horizontal pod autoscaling to
  # work with this release.
  create: true

hostNetwork:
  # Specifies if metrics-server should be started in hostNetwork mode.
  #
  # You would require this enabled if you use alternate overlay networking for pods and
  # API server unable to communicate with metrics-server. As an example, this is required
  # if you use Weave network on EKS
  enabled: false

image:
  repository: gcr.io/google_containers/metrics-server-amd64
  tag: ${metrics_server_version}
  pullPolicy: IfNotPresent

imagePullSecrets: []
# - registrySecretName

args: []
# enable this if you have self-signed certificates, see: https://github.com/kubernetes-incubator/metrics-server
#  - --kubelet-insecure-tls

# https://github.com/kubernetes/kubernetes/blob/master/cluster/addons/metrics-server/metrics-server-deployment.yaml
# pod nanny addon can resize?
resources:
  limits:
    cpu: 100m
    memory: 300Mi
  requests:
    cpu: 5m
    memory: 50Mi



nodeSelector: {}

tolerations: []

affinity: {}

replicas: 1

extraContainers: []

podLabels: {}

podAnnotations: {}
#  The following annotations guarantee scheduling for critical add-on pods.
#    See more at: https://kubernetes.io/docs/tasks/administer-cluster/guaranteed-scheduling-critical-addon-pods/
#  scheduler.alpha.kubernetes.io/critical-pod: ''
priorityClassName: system-node-critical

extraVolumeMounts: []
#  - name: secrets
#    mountPath: /etc/kubernetes/secrets
#    readOnly: true

extraVolumes: []
#  - name: secrets
#    secret:
#      secretName: kube-apiserver

livenessProbe:
  httpGet:
    path: /healthz
    port: https
    scheme: HTTPS
  initialDelaySeconds: 20

readinessProbe:
  httpGet:
    path: /healthz
    port: https
    scheme: HTTPS
  initialDelaySeconds: 20

securityContext:
  allowPrivilegeEscalation: false
  capabilities:
    drop: ["all"]
  readOnlyRootFilesystem: true
  runAsGroup: 10001
  runAsNonRoot: true
  runAsUser: 10001

service:
  annotations: {}
  labels: {}
  #  Add these labels to have metrics-server show up in `kubectl cluster-info`
  #  kubernetes.io/cluster-service: "true"
  #  kubernetes.io/name: "Metrics-server"
  port: 443
  type: ClusterIP

podDisruptionBudget:
  # https://kubernetes.io/docs/tasks/run-application/configure-pdb/
  enabled: false
  minAvailable:
  maxUnavailable:%                                                                                                                                                                                         [9:42:40] ➜  eks git:(k8s-hpa) ✗ service:
  annotations: {}
  labels: {}
  #  Add these labels to have metrics-server show up in `kubectl cluster-info`
  #  kubernetes.io/cluster-service: "true"
  #  kubernetes.io/name: "Metrics-server"
  port: 443
  type: ClusterIP

podDisruptionBudget:
  # https://kubernetes.io/docs/tasks/run-application/configure-pdb/
  enabled: false
  minAvailable:
  maxUnavailable:
