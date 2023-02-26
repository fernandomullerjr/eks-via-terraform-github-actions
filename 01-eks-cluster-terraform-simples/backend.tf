terraform {
  cloud {
    organization = "Fernando-Labs"

    workspaces {
      name = "eks-via-terraform"
    }
  }
}
