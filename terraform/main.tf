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

  # Ports
  web_backend_port = var.web_backend_port
  web_ui_port      = var.web_ui_port
  rds_port         = var.rds_port

  # ALB ingress
  alb_ingress_ports = var.alb_ingress_ports
  alb_ingress_cidr  = var.alb_ingress_cidr

  tags = var.tags
}

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

  # SG: dotnet → backend SG, остальное → web UI SG
  sgs = [
    each.key == "dotnet"
    ? module.security_groups.web_backend_security_group_id
    : module.security_groups.web_ui_security_group_id
  ]

  create_iam_instance_profile = true
  iam_role_description        = "IAM role for EC2 instance"
  iam_role_policies           = var.iam_role_policies

  # Порты на хосте
  web_ui_port      = var.web_ui_port      # 80
  web_backend_port = var.web_backend_port # 8080

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

  # Docker-образы: кому что
  docker_backend_image = each.key == "dotnet" ? "pavlovaalla88/secret-nick-api:0.1.3" : ""
  docker_front_image   = each.key == "react" ? "pavlovaalla88/secret-nick-front:0.1.3" : ""
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