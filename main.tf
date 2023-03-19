terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

#login with aws 
provider "aws" {
  region     = "us-east-1"
  access_key = "AKIAVVSYG7MPDTCMD5MW"
  secret_key = "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"
}




# variables for inbound rules
variable "ingress-rules" {
  type = list(number)
  default = [ 22,8080,80,443 ]
  
}

# variables for outbound rules
variable "egress-rules" {
  type = list(number)
  default = [ 22,8080,80,443,25 ]  #25--> for email
}


#security group

resource "aws_security_group" "webtraffic" {
  name        = "webtraffic"
  description = "Allow inbound and outbound traffic"

  dynamic "ingress" {
    iterator = port
    for_each = var.ingress-rules
    content {
         description      = "Inbound Rules"
         from_port        = port.value
         to_port          = port.value
         protocol         = "TCP"
         cidr_blocks      = ["0.0.0.0/0"] 
    }
  }

 dynamic "egress" {
    iterator = port
    for_each = var.egress-rules
    content {
         description      = "outbound Rules"
         from_port        = port.value
         to_port          = port.value
         protocol         = "TCP"
         cidr_blocks      = ["0.0.0.0/0"] 
    }
  }
}



resource "aws_instance" "ec2" {
  ami = "ami-00874d747dde814fa"
  instance_type = "t2.micro"
  key_name = "Terraform_Automation"
  vpc_security_group_ids = [aws_security_group.webtraffic.id]
  tags = {
    Name = "web server"
  }

  # configuring the machine
  provisioner "remote-exec" {
    inline = [
      "sudo apt update && upgrade",
      "sudo apt install software-properties-common -y",
      "sudo add-apt-repository --yes  ppa:deadsnakes/ppa",
      "sudo apt update -y",
      "sudo apt install python2 -y",
      "sudo apt install default-jdk -y",
      "sudo wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -",
      "sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'"
    ]
    connection {
      type = "ssh"
      user = "ubuntu"
      private_key = file("/home/ubuntu/.ssh/Terraform_Automation.pem")
      host = aws_instance.ec2.public_ip
    }

  }
 #this will store the ip address for later ansible configuration
  provisioner "local-exec" {
    command =" echo '[web-servers]' > inventory"
  }

  provisioner "local-exec" {
    command = "echo '${aws_instance.ec2.public_ip}' >> inventory"
  }
  #we will setup jenkins using ansible playbook 
    provisioner "local-exec" {
    command = "ansible-playbook task.yml -i /home/ubuntu/terraform_project/inventory --private-key=/home/ubuntu/.ssh/Terraform_Automation.pem"
  }
     
}

