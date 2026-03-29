module "prometheus" {
  source = "../../modules/prometheus"

  prometheus_release_name      = var.prometheus_release_name
  prometheus_namespace         = var.prometheus_namespace
  prometheus_chart_version     = var.prometheus_chart_version
  prometheus_repository        = var.prometheus_repository
  prometheus_chart_name        = var.prometheus_chart_name
  prometheus_create_namespace  = var.prometheus_create_namespace
  prometheus_scrape_interval   = var.prometheus_scrape_interval
  prometheus_evaluation_interval = var.prometheus_evaluation_interval
  prometheus_scrape_timeout    = var.prometheus_scrape_timeout
}