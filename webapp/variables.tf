variable "username" {
  default = "unknown visitor"
  type        = "string"
  description = "nom de l'utilisateur reference dans la webapp"
}

variable "azs" {
  type    = "list"
  default = ["eu-west-1a", "eu-west-1b"]
}

variable "subnets" {
  type    = "list"
  default = ["subnet1", "subnet2"]
}
