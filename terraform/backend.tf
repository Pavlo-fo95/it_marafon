terraform {
  backend "s3" {
    bucket  = "terraform-state-pavlo-2025"  
    key     = "envs/prod/terraform.tfstate" 
    region  = "eu-central-1"
    encrypt = true
  }
}
