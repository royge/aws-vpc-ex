provider "aws" {
  region = "${var.region}"
}

resource "aws_vpc" "basic" {
  cidr_block = "${var.cidr_blocks[0]}"

  tags {
    Name = "${var.namespace} - VPC"
  }
}

resource "aws_internet_gateway" "basic" {
  vpc_id = "${aws_vpc.basic.id}"

  tags {
    Name = "${var.namespace} - Internet Gateway"
  }
}

resource "aws_route_table" "basic" {
  vpc_id = "${aws_vpc.basic.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.basic.id}"
  }

  tags {
    Name = "${var.namespace} - Route Table"
  }
}

resource "aws_main_route_table_association" "basic" {
  vpc_id = "${aws_vpc.basic.id}"
  route_table_id = "${aws_route_table.basic.id}"
}

resource "aws_subnet" "primary" {
  vpc_id = "${aws_vpc.basic.id}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
  cidr_block = "${var.cidr_blocks[1]}"

  tags {
    Name = "${var.namespace} - Primary"
  }
}

resource "aws_subnet" "secondary" {
  vpc_id = "${aws_vpc.basic.id}"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"
  cidr_block = "${var.cidr_blocks[2]}"

  tags {
    Name = "${var.namespace} - Secondary"
  }
}

output "primary_subnet_id" {
  value = "${aws_subnet.primary.id}"
}

output "secondary_subnet_id" {
  value = "${aws_subnet.secondary.id}"
}
