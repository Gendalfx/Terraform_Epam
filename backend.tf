terraform {
  required_version = ">= 1.3.0"

  backend "s3" {
    bucket         = "my-terraform-state-bucket-andrii-dukhvin"
    key            = "global/s3/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}
