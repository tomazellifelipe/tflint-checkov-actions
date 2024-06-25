terraform {
  required_version = ">= 1.3.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5"
    }
  }
}

provider "aws" {

}

resource "aws_s3_bucket" "this" {
  bucket_prefix = "tflint-checkov"
}
