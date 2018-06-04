# Provider Variables
provider "aws" {
  region     = "us-east-1"
}

# Keypair
variable "public_key" {default = "jumpbox-key.pub"}
variable "private_key" {default = "jumpbox-key"}

resource "aws_key_pair" "jumpbox" {
key_name  = "jumpbox-key"
  public_key = "${file("${path.cwd}/${var.public_key}")}"
}

# Resource
## Security Group
resource "aws_security_group" "jumpbox" {
  name        = "jumpbox_sg"
  description = "Allow traffic needed by jumpbox"

  ### ssh
  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ### all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

## Resource Variables
variable "ami" {
  default = "ami-176ad968" // Ubuntu 18.04 in us-east-1
}

variable "instance_type" {
  default = "t2.micro"
}

## Resource
resource "aws_instance" "jumpbox" {
  tags {
    Name = "jumpbox"
  }

  ami                         = "${var.ami}"
  instance_type               = "${var.instance_type}"
  associate_public_ip_address = true
  key_name                    = "${aws_key_pair.jumpbox.key_name}"
  vpc_security_group_ids      = ["${aws_security_group.jumpbox.id}"]

  
  connection {
    type        = "ssh"
    host        = "${aws_instance.jumpbox.public_ip}"
    user        = "ubuntu"
    port        = "22"
    private_key = "${file("${path.cwd}/${var.private_key}")}"
    agent       = false
  }

  provisioner "file" {
  source      = "provision.sh"
  destination = "/tmp/provision.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sleep 120",
      "chmod +x /tmp/provision.sh",
      "sudo /tmp/provision.sh",
    ]
  }
}
