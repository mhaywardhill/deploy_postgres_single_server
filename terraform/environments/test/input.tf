variable project_name {}

variable location {}

variable environment_name {
	default = "test"
}

variable db_password {
  description = "Password"
  type        = string
  sensitive   = true
}




