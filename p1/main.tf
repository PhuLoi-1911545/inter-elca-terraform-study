provider "aws" {
    region = "ap-southeast-2"
    access_key = "AKIATLSF73HKN25FQGFU"
    secret_key = "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"
  
}

# part 2
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  owners = ["099720109477"] # Canonical Ubuntu AWS account id
}


#part 1
resource "aws_instance" "terraform-testing" {
    ami           = "ami-07620139298af599e" # part 1
    # ami           = data.aws_ami.ubuntu.id # part 2
    instance_type = "t2.micro"

    tags = {
      "Name" = "tf-testing"
    }
    
}

resource "aws_s3_bucket" "terraform-bucket" {
  bucket = "terraform-series-bucket"

  tags = {
    Name        = "Terraform Series"
  }
}