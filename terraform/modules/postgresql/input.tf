variable location {}
variable resource_group {}
variable server_name {}
variable db_username {}
variable db_password {}
variable log_analytics_workspace_id {}


variable server_parameters {
  type = list(object({
    key          = string
    value        = string
  }))
  default = [
    {
      key          = "log_line_prefix"
      value        =  "%m-%p-%l-%u-%d-%a-%h-"
    },
    {
      key          = "logging_collector"
      value        = "OFF"
    }
  ]
}
