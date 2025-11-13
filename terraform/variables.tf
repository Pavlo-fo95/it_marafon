################################ 
# Global
################################

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "project" {
  description = "Project name (tag)"
  type        = string
}

variable "env" {
  description = "Environment (tag)"
  type        = string
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}

#теги образов (ECR/контейнеры) —  интерфейс
variable "backend_image_tag" {
  type    = string
  default = null
}

variable "frontend_image_tag" {
  type    = string
  default = null
}

################################
# VPC
################################

variable "vpc_name" {
  description = "VPC name"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
}

variable "subnets" {
  description = "Map of subnets"
  type = map(object({
    cidr_block = string
    public     = bool
    az_index   = optional(number)
  }))
}

variable "az_letter" {
  description = "AZ letter suffix (a|b|c)"
  type        = string
}

################################
# SG / ALB / Ports
################################

variable "project_name" {
  description = "Name prefix for resources"
  type        = string
}

variable "web_backend_port" {
  description = "Backend port"
  type        = number
}

variable "web_ui_port" {
  description = "Frontend/UI port"
  type        = number
}

variable "alb_ingress_ports" {
  description = "Ports allowed on ALB"
  type        = list(number)
}

variable "alb_ingress_cidr" {
  description = "CIDRs allowed to ALB"
  type        = list(string)
}

################################
# EC2
################################

variable "ec2_name_set" {
  description = "Set of EC2 instance names"
  type        = set(string)
  default     = []
}

variable "ami" {
  description = "AMI id (must match instance arch)"
  type        = string
  default     = null
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t4g.micro"
}

# внутренняя переменная модуля ec2
variable "subnet" {
  description = "Subnet id (used by module/03-ec2)"
  type        = string
  default     = null
}

variable "sgs" {
  description = "Security Groups ids (used by module/03-ec2)"
  type        = list(string)
  default     = []
}

variable "associate_public_ip_address" {
  description = "Associate public IP to instance"
  type        = bool
  default     = true
}

variable "availability_zone" {
  description = "AZ (optional)"
  type        = string
  default     = null
}

variable "iam_instance_profile" {
  description = "IAM instance profile name"
  type        = string
  default     = null
}

variable "create_iam_instance_profile" {
  description = "Create IAM instance profile for EC2"
  type        = bool
  default     = true
}

variable "iam_role_name" {
  description = "IAM role name"
  type        = string
  default     = null
}

variable "iam_role_use_name_prefix" {
  description = "Use role name as prefix"
  type        = bool
  default     = true
}

variable "iam_role_path" {
  description = "IAM role path"
  type        = string
  default     = null
}

variable "iam_role_policies" {
  description = "Policies attached to IAM role"
  type        = map(string)
  default     = {}
}

################################
# Feature flags
################################

variable "enable_rds" {
  type    = bool
  default = false
}

variable "enable_alb" {
  type    = bool
  default = true
}

################################
# RDS
################################

variable "rds_port" {
  description = "RDS port"
  type        = number
  default     = 5432
}

variable "db_id" {
  description = "RDS instance id"
  type        = string
  default     = "postgres-db"
}

variable "db_username" {
  description = "RDS master username"
  type        = string
  sensitive   = true
  default     = "postgres"
}

variable "db_engine" {
  description = "RDS engine"
  type        = string
  default     = "postgres"
}

variable "db_engine_version" {
  description = "RDS engine version"
  type        = string
  default     = "17.5"
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "db_storage_size" {
  description = "RDS storage size (GB)"
  type        = number
  default     = 20
}

variable "db_subnet_group_name" {
  description = "RDS subnet group name"
  type        = string
  default     = "rds-private-subnet-group"
}
