variable "db_subnets" {
  type = list(string)
}

variable "common_tags" {
  type = map(string)
}

variable "db_security_group" {
  type = list(string)
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type = string
  sensitive = true
}

variable "kms_key_id" {
  type = string
}