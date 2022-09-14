provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

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

resource "null_resource" "port-forward" {
  depends_on = [helm_release.kubecost]
  provisioner "local-exec" {
    command = "kubectl port-forward -n kubecost svc/kubecost-cost-analyzer 9090:9090"
  }
}