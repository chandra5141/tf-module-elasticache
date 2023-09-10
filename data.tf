data "aws_ssm_parameter" "elasticache_user" {
  name = "${var.env}.elasticache.user"
}

data "aws_ssm_parameter" "elasticache_password" {
  name = "${var.env}.elasticache.password"
}
data "aws_kms_key" "key" {
  key_id = "alias/roboshop"
}