resource "aws_security_group" "public" {
  name = "${var.namespace}-public"
  description = "Public access"
  vpc_id = "${aws_vpc.basic.id}"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "internal" {
  name = "${var.namespace}-internal"
  description = "HTTP(s) access within the full internal network"
  vpc_id = "${aws_vpc.basic.id}"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = ["${aws_security_group.public.id}"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = "${var.ssh_cidr_blocks}"
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "public_sg_id" {
  value = "${aws_security_group.public.id}"
}

output "internal_sg_id" {
  value = "${aws_security_group.internal.id}"
}
