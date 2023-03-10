variable "name" {
    description = "the name of the variable set"
    type        = string 
}

variable "description" {
    description = "the description of the variable set."
    type        = string 
}

variable "templates" {
    description = "array of variable templates"
    type        = any
    default     = []
}

variable "variables" {
    description = "list of variables"
    type        = any 
    default     = []
}