variable "prefix" {
  description = "prefix used for rg and server name"
  type        = string
  default     = "postgressql783939443"
}

variable "db_username" {
  description = "username"
  type        = string
  default     = "PFZH73kuFw"
}

variable "db_password" {
  description = "password"
  type        = string
  sensitive   = true
}