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

locals {
  bucket = {
    "name-prefix" = "tflint-checkov"
  }
}

resource "aws_s3_bucket" "tflint_checkov" {
  for_each      = local.bucket
  bucket_prefix = each.value.name-prefix
  force_destroy = true
}

resource "aws_s3_bucket_lifecycle_configuration" "abort_incomplete_multipart" {
  for_each = local.bucket
  bucket   = aws_s3_bucket.tflint_checkov[each.key].id
  rule {
    id     = "abort-incomplete-multipart-uploads"
    status = "Enabled"
    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }

}

resource "aws_s3_bucket_public_access_block" "block_all" {
  for_each                = local.bucket
  bucket                  = aws_s3_bucket.tflint_checkov[each.key].id
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}
