output "resource_group" {
    value="${var.project_name}-resources-${var.environment_name}"
}

output "server_name" {
    value="${var.project_name}-pgss-${var.environment_name}"
}

