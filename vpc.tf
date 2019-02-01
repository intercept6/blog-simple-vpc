resource "aws_vpc" "main" {
  cidr_block           = "${var.cidr_block}"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags                 = "${merge(local.base_tag, map("Name", "${local.base_name}-vpc"))}"
}

resource "aws_subnet" "main" {
  count             = "${var.num_subnets}"
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${cidrsubnet(var.cidr_block, 8, count.index % var.num_subnets)}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index % var.num_subnets]}"

  tags = "${merge(local.base_tag, map("Name", "${local.base_name}-subnet${count.index+1}"))}"
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.main.id}"

  tags = "${merge(local.base_tag, map("Name", "${local.base_name}-vpc"))}"
}

resource "aws_route" "to_inet" {
  route_table_id         = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.gw.id}"
}

resource "aws_route_table_association" "a" {
  count          = "${var.num_subnets}"
  subnet_id      = "${element(aws_subnet.main.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.main.id}"

  tags = "${merge(local.base_tag, map("Name", "${local.base_name}-gw"))}"
}
