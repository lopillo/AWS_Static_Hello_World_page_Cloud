terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
}

# Provider block to specify the AWS provider and the region.
provider "aws" {
  region = "eu-central-1"
}



