

# ---------------------------------------------------------------------------------------------------------------------
# ENVIRONMENT VARIABLES
# Define these secrets as environment variables
# ---------------------------------------------------------------------------------------------------------------------

variable "aws_access_key_id_var" {
  description = "AWS_ACCESS_KEY_ID"
  type        = string
  default     = ENV_AWS_ACCESS_KEY_ID
}

variable "aws_secret_access_key_id_var" {
  description = "AWS_SECRET_ACCESS_KEY"
  type        = string
  default     = ENV_AWS_ACCESS_KEY_ID
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 8080
}
