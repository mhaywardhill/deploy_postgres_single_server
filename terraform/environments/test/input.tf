variable project_name {
  description = "Project prefix"
  type        = string
}

variable location {}

variable environment_name {
	default = "test"
}

variable db_username {
	default = "KFZH93kuFw"
}

variable db_password {
  description = "Password"
  type        = string
  sensitive   = true
}




