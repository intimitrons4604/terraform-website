provider "aws" {
  region = "us-west-2"
}

provider "aws" {
  alias = "us_east_1"

  region = "us-east-1"
}

data "terraform_remote_state" "dns" {
  backend = "remote"
  config = {
    hostname     = "app.terraform.io"
    organization = "intimitrons"
    workspaces = {
      name = "dns-prod"
    }
  }
}
