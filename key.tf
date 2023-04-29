resource "tls_private_key" "Web-Key" {
  algorithm = "RSA"
}


#Save public key attributes from the generated key
resource "aws_key_pair" "App-Instance-Key" {
  key_name   = "Web-key"
  public_key = tls_private_key.Web-Key.public_key_openssh
}


#Save the key to your local system
resource "local_file" "Web-Key" {
  content  = tls_private_key.Web-Key.private_key_pem
  filename = "Web-Key.pem"
}
