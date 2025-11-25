variable "access_key" {
  type      = string
  default   = ""
  sensitive = true
}
variable "secret_key" {
  type      = string
  default   = ""
  sensitive = true
}
variable "region" {
  type    = string
  default = "eu-west-1"
}
variable "ServerName" {
  type    = string
  default = "app-1-server-1"
}
variable "colors" {
  type    = list(string)
  default = ["yellow", "blue"]
}
variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}
variable "availability_zones" {
  description = "List of AZs"
  type        = list(string)
  default     = ["eu-west-1a", "eu-west-1b"]
}
