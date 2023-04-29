resource "aws_instance" "Web" {
  ami                    = "ami-02396cdd13e9a1257"

  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.sig.id]
  key_name = "Web-key"
  subnet_id = aws_subnet.my_app-subnet.id
  tags = {
    Name = "WebServer1"
  }


  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("Web-Key.pem")
    host        = aws_instance.Web.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install httpd  php git -y",
      "sudo systemctl restart httpd",
      "sudo systemctl enable httpd",

    ]
  }
}
