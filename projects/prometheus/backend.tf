#Ues local backend folder to store state files
terraform {
  backend "local" {
    path = "relative/path/to/terraform.tfstate"
  }
}