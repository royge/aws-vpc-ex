module "basicawsvpc" {
  source = "../../basic"

  region = "ap-southeast-1"
  namespace = "awsbrownbag"

  cidr_blocks = [
    # VPC
    "10.0.0.0/16",
    # Primary subnet
    "10.0.1.0/24",
    # Secondary subnet
    "10.0.2.0/24"
  ]

  ssh_cidr_blocks = [
    # Allowed IP to SSH
    "110.54.231.183/32"
  ]
}

resource "aws_instance" "test" {
  count = 1
  ami = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.nano"
  associate_public_ip_address = true
  vpc_security_group_ids = [
    #"${module.basicawsvpc.public_sg_id}",
    "${module.basicawsvpc.internal_sg_id}"
  ]
  subnet_id = "${module.basicawsvpc.primary_subnet_id}"
  key_name = "arcanysbrownbag"

  tags {
    Name = "awsbrownbag - Test"
  }
}

resource "aws_instance" "test-public" {
  count = 1
  ami = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.nano"
  associate_public_ip_address = true
  vpc_security_group_ids = [
    "${module.basicawsvpc.public_sg_id}",
    "${module.basicawsvpc.internal_sg_id}"
  ]
  subnet_id = "${module.basicawsvpc.primary_subnet_id}"
  key_name = "arcanysbrownbag"

  tags {
    Name = "awsbrownbag - Test public"
  }
}
