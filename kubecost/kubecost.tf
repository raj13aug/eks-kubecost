resource "kubernetes_namespace" "kubecost" {
  count = var.enable_kubecost ? 1 : 0
  metadata {
    name = var.kubecost_namespace
    # labels = {
    #   istio-injection = "enabled"
    # }
  }
}

resource "helm_release" "kubecost" {
  depends_on = [helm_release.istio_istiod]
  count      = var.enable_kubecost ? 1 : 0
  name       = "kubecost"
  version    = var.kubecost_helm_chart_version
  chart      = "cost-analyzer"
  repository = "https://kubecost.github.io/cost-analyzer/"
  namespace  = kubernetes_namespace.kubecost.0.metadata.0.name
  wait       = true

  values = [var.kubecost_helm_chart_values]

  set {
    name  = "kubecostToken"
    value = var.kubecost_token
  }
}