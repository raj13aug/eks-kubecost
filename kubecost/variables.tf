variable "kubecost_namespace" {
  type    = string
  default = "kubecost"
}

variable "kubecost_helm_chart_values" {
  type        = string
  description = "Values in raw yaml to pass to helm to override defaults in the Kubecost Helm Chart."
  default     = ""
}

variable "kubecost_helm_chart_version" {
  default     = "1.96.0"
  type        = string
  description = "The helm chart version of Kubecost. Versions can be found here https://github.com/kubecost/cost-analyzer-helm-chart/releases"
}

variable "kubecost_token" {
  default     = ""
  type        = string
  description = "A user token for Kubecost, obtained from the Kubecost organization. Can be obtained by providing email here https://kubecost.com/install"
}

variable "enable_kubecost" {
  default = true
  type    = bool
}