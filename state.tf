terraform {
  backend "s3" {
    bucket = "pushp-tf-state-bucket"
    key ="app/history_load/history-star.tfstate"
    region = "us-east-1"
  }
}