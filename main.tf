resource "aws_elasticache_subnet_group" "elasticache_subnet_group" {
  name       = "${var.env}_elasticache_subnet_group"
  subnet_ids = var.subnet_ids

  tags = merge(
    local.common_tags,
    { Name = "${var.env}_elasticache_subnet_group" }
  )
}

resource "aws_security_group" "elasticache_sg" {
  name        = "${var.env}_elasticache_security_group"
  description = "${var.env}_elasticache_security_group"
  vpc_id      = var.vpc_id


  ingress {
    description      = "elasticache"
    from_port        = 6379
    to_port          = 6379
    protocol         = "tcp"
    cidr_blocks      = var.allow_cidr

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = merge(
    local.common_tags,
    { Name = "${var.env}_elasticache_security_group" }
  )

}

resource "aws_elasticache_replication_group" "elasticache_replication_group" {
  replication_group_id        = "${var.env}_elasticache_rg"
  description                 = "${var.env}_elasticache_rg"
  node_type                   = var.node_type
  num_node_groups             = var.num_node_groups
  replicas_per_node_group     = var.replicas_per_node_group
  port                        = 6379
  subnet_group_name           = aws_elasticache_subnet_group.elasticache_subnet_group.name
  security_group_ids = [aws_security_group.elasticache_sg.id]

  tags = merge(
    local.common_tags,
    { Name = "${var.env}_elasticache_replication_group" }
  )
}
