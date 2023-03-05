terraform {
  cloud {
    organization = "Fernando-Labs"

    workspaces {
      name = "eks-via-terraform"
    }
  }
}

#provider "aws" {
#  region  = var.aws_region
#  profile = "default"
#}


provider "aws" {
  region  = var.aws_region
  shared_credentials_file = "$HOME/.aws/credentials"
  profile                  = "default"
}