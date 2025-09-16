#Use this in case you want to have s3 as backend
terraform {
    backend "s3" {
    bucket         = "open-tofu-backend"
    key            = "tofu-state-file.tfstate"
    region         = "ap-south-1" # Or your desired region
    encrypt        = true
    }
}