#Ues local backend folder to store state files
terraform {
  backend "local" {
    path = "./state/terraform.tfstate"
  }
}