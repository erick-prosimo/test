terraform {
  required_version = ">=0.13"
  required_providers {
    prosimo = {
      source  = "prosimo.io/prosimo/prosimo"
      version = "1.0.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "4.14.0"
    }
  }
}