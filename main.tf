provider "aws" {
  region = "us-west-1"
}

# Create instance
resource "aws_instance" "webserver" {
  ami = "ami-03978d951b279ec0b"
  instance_type = "t2.micro"
  key_name ="terraformm"
  for_each = toset(["jump-server","app-server","db-server"])
  vpc_security_group_ids = [aws_security_group.my_sg.id]
  tags = {
    Name = each.key
  }
}

# Create security Group
resource "aws_security_group" "my_sg" {
  name = "mytf_sg"
ingress {
    description = "allow ssh"
    to_port = 22
    from_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}
ingress {
    description = "http"
    to_port = 80
    from_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}
ingress {
    description = "https"
    to_port = 443
    from_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}
egress {
    description = "allow all traffic"
    to_port = 0
    from_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
}
}

# Create S3 bucket with enabed versioning
resource "aws_s3_bucket" "my_bucket"{
  bucket = "dhanu1211"
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.my_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}