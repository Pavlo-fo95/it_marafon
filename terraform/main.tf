################################################################################
# VPC / Network
################################################################################

module "vpc" {
  source   = "./modules/01-vpc"
  vpc_cidr = var.vpc_cidr
  vpc_name = var.vpc_name
  subnets  = var.subnets
}

################################################################################
# Security Groups
################################################################################

module "security_groups" {
  source = "./modules/02-sg"

  vpc_id      = module.vpc.vpc_id
  name_prefix = var.project_name

  web_backend_port = var.web_backend_port
  web_ui_port      = var.web_ui_port
  rds_port         = var.rds_port

  alb_ingress_ports = var.alb_ingress_ports
  alb_ingress_cidr  = var.alb_ingress_cidr

  tags = var.tags
}

################################################################################
# SSH Key Pair
################################################################################

# resource "aws_key_pair" "new_marafon_key" {
#   key_name   = "new-marafon-key"
#   public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCv2pXkdKtnbU6L8pAdckTRrz9RdNyXZkKFQK3aqIV+mvbEx/8s4Qj3BU1cs2Hxo3lYLJtSbiRx03aAIblztCksVtFtjifLcoqc/AaP3MiaUOMpL84oyydKldmcwmIERaf4TXMpxaczP3DBGbo5yPx3SJacYRV6yPVggyCkUc0XFJwWXd3/kiJ7eELo+6cYBNOKGDEV2yx8Uqs2CZ19lj1lwA/BMxvndNkSRGKbv6XMVfYeSmXWl0jNNzz1q8oxxMiypoW+DGe7vxU7YUJIT6hPybNtvNQOv0eUASQp3bIbllhic873po69CQ/pYwksX4uZYr4ADq3ucv0/I2s0fZzMTxOmuWgfrQXgLmWTwiEmRKVcyVSh98NuBiIklHdRyynsAxujNk/7G5UodUKNQ4/0tsIrvCSfe9BS98thhZZIO0ZeZIxSB08wf2F3+qaq33Ozt6EcJb7R0sAKI9h61reNn884y1xNPfjWYjizazcg3tEsi/+USnEaJm7xRzjqgyLvoVKJiqg0//ocN6hgbJSRmiiHy5PZDpDInWbCJrk6leuC26bHrzESqNZhReBq3pr5Zs1BAveHfwY+ltbOOwSt6dcEmMrjfRQuMB8A7YtlUHOtxQEK+PiqrbQEUncZwyJr2oCxyyhBxosauasEL/opl/B1PKx5O4Jq91WVpyUAgw== pavlo@DESKTOP-AF2ND4E"
# }

################################################################################
# EC2 instances (react, angular, dotnet)
################################################################################

module "ec2" {
  for_each = toset(var.ec2_name_set)

  source = "./modules/03-ec2"

  ami           = var.ami
  ec2_name      = each.key
  instance_type = var.instance_type

  # Берём первую публичную подсеть
  subnet = module.vpc.vpc_subnet_ids["subnet0"]

  # SG: dotnet → backend SG, остальные → web UI SG
  sgs = [
    each.key == "dotnet"
    ? module.security_groups.web_backend_security_group_id
    : module.security_groups.web_ui_security_group_id
  ]

  create_iam_instance_profile = true
  iam_role_description        = "IAM role for EC2 instance"
  iam_role_policies           = var.iam_role_policies

  # Порты
  web_ui_port      = var.web_ui_port
  web_backend_port = var.web_backend_port

  # Порт для target group attachment
  port = each.key == "dotnet" ? var.web_backend_port : var.web_ui_port

  # Привязка к нужному target group’у
  target_group_arn = (
    each.key == "angular" ? module.alb.web_ui_angular_target_group_arn :
    each.key == "react" ? module.alb.web_ui_react_target_group_arn :
    each.key == "dotnet" ? module.alb.backend_target_group_arn :
    null
  )

  associate_public_ip_address = true

  # Docker-образы
  docker_backend_image = each.key == "dotnet" ? "pavlovaalla88/secret-nick-api:0.1.3" : ""
  docker_front_image   = each.key == "react" ? "pavlovaalla88/secret-nick-front:0.1.3" : ""

  # ⭐ вот тут передаём key pair во все EC2
  key_name = aws_key_pair.new_marafon_key.key_name
}

################################################################################
# RDS
################################################################################

module "rds" {
  source = "./modules/04-rds"

  db_id                = var.db_id
  db_username          = var.db_username
  db_subnet_group_name = var.db_subnet_group_name
  rds_port             = var.rds_port
  db_engine            = var.db_engine
  db_engine_version    = var.db_engine_version
  db_storage_size      = var.db_storage_size
  db_instance_class    = var.db_instance_class

  db_vpc_sg_ids  = [module.security_groups.rds_instance_security_group_id]
  vpc_subnet_ids = module.vpc.private_subnet_ids
}

################################################################################
# ALB
################################################################################

module "alb" {
  source = "./modules/05-alb"

  tags              = var.tags
  name              = "${var.project_name}-alb"
  vpc_id            = module.vpc.vpc_id
  subnet_ids        = module.vpc.public_subnet_ids
  security_group_id = module.security_groups.alb_security_group_id

  web_backend_port = var.web_backend_port
  web_ui_port      = var.web_ui_port
}