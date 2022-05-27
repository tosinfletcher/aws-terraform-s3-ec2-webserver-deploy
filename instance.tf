provider "aws" {
  region = var.region
}

data "aws_ssm_parameter" "amazon_linux_ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}


resource "aws_instance" "tfletcher_web" {
  ami                         = data.aws_ssm_parameter.amazon_linux_ami.value
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.tfletcher_public.id
  key_name                    = "tfletcher-keypair"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.tfletcher_sg.id]

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file("/home/tfletcher/files/tfletcher-keypair.pem")

  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y && sudo yum upgrade -y",
      "sudo yum install git -y",
      "sudo yum install httpd -y",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd"
    ]
  }



  provisioner "file" {
    source      = "./index.html"
    destination = "/tmp/index.html"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo cp /tmp/index.html /var/www/html/index.html"
    ]
  }


  tags = {
    Name = "tfletcher_web"
  }
}

