variable "username" {
  default     = "unknown visitor"
  type        = "string"
  description = "nom de l'utilisateur reference dans la webapp"
}

variable "ami_id" {
  default = "ami-0e44b1e683936b9f0"
  type = "string"
  description = "AMI generee par packer"
}
