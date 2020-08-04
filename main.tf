provider "aws" {
  version = "2.64.0"
  region  = "us-west-2"
}

provider "aws" {
  alias = "us-east-1"

  version = "~> 2.0"
  region  = "us-east-1"
}

data "terraform_remote_state" "dns" {
  backend = "remote"
  config = {
    hostname     = "app.terraform.io"
    organization = "intimitrons"
    workspaces = {
      name = "dns"
    }
  }
}
