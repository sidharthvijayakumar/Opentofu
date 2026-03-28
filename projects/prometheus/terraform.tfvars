##########################################
#Prometheus
#########################################
prometheus_release_name        = "kube-prometheus-stackr"
prometheus_namespace           = "prometheus"
prometheus_chart_version       = "70.3.0"
prometheus_repository          = "https://prometheus-community.github.io/helm-charts"
prometheus_chart_name          = "kube-prometheus-stack"
prometheus_create_namespace    = true
prometheus_scrape_timeout      = "15s"
prometheus_evaluation_interval = "15s"
prometheus_scrape_interval     = "15s"