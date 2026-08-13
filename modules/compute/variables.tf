variable "app_subnet_ids" {
  type = list(string)
}

variable "app_security_groups" {
  type = list(string)
}

variable "iam_instance_profile" {
  type = string
}

variable "common_tags" {
  type = map(string)
}

variable "target_group_arn" {
  type = list(string)
}