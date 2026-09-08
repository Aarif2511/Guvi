provider "aws" {
  region = "ap-south-1"
}

provider "aws" {
  alias  = "west"
  region = "ap-south-2"
}

resource "aws_instance" "south-1" {
  ami           = "ami-081f2952afeacc0ba"
  instance_type = "t3.micro"
}

resource "aws_instance" "south-2" {
  provider      = aws.west
  ami           = "ami-0b5edb98441c02861"
  instance_type = "t3.micro"
}
