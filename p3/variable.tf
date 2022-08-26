variable "instance_public_type" {
    type = string
    description = "This is instance type for UI ( public) "

    validation {
      condition = contains(["t2.micro", "t3.small"], var.instance_public_type)
      error_message = "This type of instance will cost some money"
    }
  
}

variable "instance_private_type" {
    type = string
    description = "This is instance type for database ( private )"
  
}