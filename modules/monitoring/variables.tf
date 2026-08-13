variable "common_tags" {
  type = map(string)
}

variable "kms_key_id" {
  type = string
}

variable "alb_arn_suffix" {
  type = string
}

variable "asg_name" {
  type = string
}

variable "db_identifier" {
  type = string
}