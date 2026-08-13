variable "public_subnets" {
  type = list(string)
}

variable "common_tags" {
  type = map(string)
}

variable "vpc_id" {
  type = string
}

variable "alb_security_group" {
  type = list(string)
}
