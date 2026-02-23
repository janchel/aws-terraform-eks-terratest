# Test change to trigger CI/CD workflow
module "s3" {
  source = "../modules/s3"

  bucket_name = var.bucket_name
}