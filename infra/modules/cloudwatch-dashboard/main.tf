

resource "aws_cloudwatch_dashboard" "ecs_memory_dashboard" {
  dashboard_name = "Service-Dashboard"
  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          title   = "MemoryUtilization"
          view    = "singleValue"
          stacked = false
          metrics = [
            [
              "AWS/ECS",
              "MemoryUtilization",
              "ClusterName",
              var.ecs.api.cluster_name,
              "ServiceName",
              var.ecs.api.service_name,
              { "region" : var.region, label = "API Service" }
            ],
            [
              "AWS/ECS",
              "MemoryUtilization",
              "ClusterName",
              var.ecs.ui.cluster_name,
              "ServiceName",
              var.ecs.ui.service_name,
              { "region" : var.region, label = "UI Service" }
            ]
          ]
          region    = var.region
          sparkline = true
          period    = 300
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6
        properties = {
          title   = "CPUUtilization"
          view    = "singleValue"
          stacked = false
          metrics = [
            [
              "AWS/ECS",
              "CPUUtilization",
              "ClusterName",
              var.ecs.api.cluster_name,
              "ServiceName",
              var.ecs.api.service_name,
              { "region" : var.region, label = "API Service" }
            ],
            [
              "AWS/ECS",
              "CPUUtilization",
              "ClusterName",
              var.ecs.ui.cluster_name,
              "ServiceName",
              var.ecs.ui.service_name,
              { "region" : var.region, label = "UI Service" }
            ]
          ]
          region    = var.region
          sparkline = true
          period    = 300
        }
      },
      {
        type   = "log"
        x      = 0
        y      = 12
        width  = 24
        height = 9
        properties = {
          view          = "table"
          title         = "API Logs"
          query         = "SOURCE '${var.ecs.api.log_group_name}' | fields @timestamp, @message, @logStream, @log\n| sort @timestamp desc\n| limit 10000"
          region        = var.region
          stacked       = false
          logGroupNames = [var.ecs.api.log_group_name]
        }
      }
    ]
  })
}
