# modules/terraform/backend/main.tf

locals {
  tags           = merge(var.tags, { Terraform_module = "terraform_backend" })
  count          = var.enable ? 1 : 0
  backend_bucket = var.enable ? aws_s3_bucket.tf_backend[0].bucket : "none"
}


resource "aws_s3_bucket" "tf_backend" {
  count = local.count

  bucket_prefix = "tf-backend-"
  force_destroy = true

  tags = local.tags
}


resource "local_file" "backend" {
  count = local.count

  filename        = var.filename
  file_permission = "0644"

  content = <<-EOF
  # Don't edit this file. Generated by terraform
  
  terraform {
    backend "s3" {
      region = "${var.aws_region}"
      bucket = "${local.backend_bucket}"
      key    = "terraform.tfstate"
    }
  }
  EOF
}