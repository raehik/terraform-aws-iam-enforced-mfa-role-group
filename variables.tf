variable "name" {
  description = "Name of IAM role/group/policy"
}

variable "role_max_session_duration_secs" {
  description = "Maximum session duration for the role (1-12hrs)"
  default     = 3600
}
