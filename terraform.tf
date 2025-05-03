terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.57"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 3.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.10"
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.9"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.11.0"
    }

    doppler = {
      source  = "DopplerHQ/doppler"
      version = ">= 1.6.1"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}


variable "env" {
  description = "name of the environment"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}





