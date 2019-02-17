variable "namespace" {
  description = "company name etc."
}

variable "stage" {
  description = "stage e.g. prod, dev, root"
}

variable "delimiter" {
  description = "delimiter between parts in label"
  default     = "-"
}

variable "tags" {
  description = "extra tags"
  type = "map"
  default = {}
}
