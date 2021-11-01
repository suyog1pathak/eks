terraform {
  backend "s3" {
    bucket = "pinaka092021"
    key    = "eks/"
    region = "ap-south-1"
  }
}