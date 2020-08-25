resource "kubernetes_horizontal_pod_autoscaler" "vulnerability_report" {
  metadata {
    name = "${var.project}-vulnerability-report"
    namespace = var.k8s_service_account_namespace
  }

  spec {
    min_replicas = 2
    max_replicas = 10

    scale_target_ref {
      kind = "Pod"
      name = "${var.project}-vulnerability-report"
    }

    target_cpu_utilization_percentage = "70"
  }
}

# Metrics server ...enables horizontal pod autoscaler(HPA) autoscaler API
resource "helm_release" "metrics-server" {
    name      = "metrics-server"
    chart     = "stable/metrics-server"
    namespace = var.k8s_service_account_namespace
    values = [
      data.template_file.values_metrics_server.rendered
    ]
}
