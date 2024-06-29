terraform {
  required_version = ">= 1.3.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5"
    }
  }
}

provider "aws" {}

resource "aws_sqs_queue" "lambda_trigger" {
  name_prefix = "tflint-checkov"
}

resource "aws_s3_bucket" "tflint_checkov" {
  bucket_prefix = "tflint-checkov"
}

resource "aws_s3_bucket_lifecycle_configuration" "abort_incomplete_multipart" {
  bucket = aws_s3_bucket.tflint_checkov.id
  rule {
    id     = "abort-incomplete-multipart-uploads"
    status = "Enabled"
    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }

}

resource "aws_s3_bucket_public_access_block" "block_all" {
  bucket                  = aws_s3_bucket.tflint_checkov.id
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}
