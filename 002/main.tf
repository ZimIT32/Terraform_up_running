provider "aws" {
    region = "us-east-2"  
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]

  user_data = <<-EOF
          #!/bin/bash
          echo "Hello World" > index.html
          nohup busybox httpd -f -p 8080 &
          EOF

  tags = {
    Name = "ubunut_webserver_001"
  }
}


resource "aws_security_group" "instance" {
  name = "ubuntu-webserver-test"

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}