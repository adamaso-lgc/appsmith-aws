terraform {
  backend "s3" {
    bucket  = "tf-backend-appsmith"
    key     = "env/sandbox/appsmith/appsmith.tfstate"
    region  = "us-east-1" 
    encrypt = true
    acl     = "bucket-owner-full-control"
  }

  required_version = ">=1.0.5"
}