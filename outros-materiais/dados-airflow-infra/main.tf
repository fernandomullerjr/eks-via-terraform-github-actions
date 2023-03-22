terraform {
  backend "s3" {
    bucket = "dados-bi-appmax"
    key    = "tfstate-airflow/terraform.tfstate"
    region = "us-east-1"
  }
}