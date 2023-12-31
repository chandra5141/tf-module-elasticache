resource "aws_elasticache_subnet_group" "ec_subnet_group" {
  name       = "${var.env}-elasticache-subnet-group"
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


resource "aws_elasticache_cluster" "elastic_cache" {
  cluster_id           = "${var.env}-elasti-cache-cluster"
  engine               = "redis"
  node_type            = var.node_type
  num_cache_nodes      = var.num_cache_nodes
  engine_version       = var.engine_version
  port                 = 6379
  subnet_group_name    = aws_elasticache_subnet_group.ec_subnet_group.name
  security_group_ids   = [aws_security_group.elasticache_sg.id]
  tags                 = merge (local.common_tags, { Name = "${var.env}-elasticache_cluster" } )

}

resource "aws_ssm_parameter" "elastic_point" {
  name  = "${var.env}.elastic_cache.endpoint"
  type  = "String"
  value = aws_elasticache_cluster.elastic_cache.cache_nodes[0].address
}