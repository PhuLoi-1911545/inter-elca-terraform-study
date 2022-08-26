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
    count = 2
    ami           = "ami-07620139298af599e" # part 1
    # ami           = data.aws_ami.ubuntu.id # part 2
    instance_type = var.instance_public_type
    tags = {
      # "Name" = "tf-testing"
      "Name" = "tf-testing-${count.index}"
    }
    
}





output "ec2_output" {
  value = {
    # public_ip = aws_instance.terraform-testing.public_ip
    public_ip_v1 = [ for i in aws_instance.terraform-testing : i.public_ip ]

    public_ip_v2 = { for i, v in aws_instance.terraform-testing : format("public_ip of instace %d ", i + 1) => v.public_ip }
    # public_ip_v2 = { for i, v in aws_instance.terraform-testing : format("public_ip%d", i + 1) => v.public_ip }
    ami_id = data.aws_ami.ubuntu.id

    instance_names = [ for i in aws_instance.terraform-testing : i.tags.Name ]
  }
  
}