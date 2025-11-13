aws_region = "eu-central-1"
project    = "it-marafon"
env        = "prod"

tags = {
  owner = "terraform"
}

# VPC
vpc_cidr = "10.0.0.0/16"
vpc_name = "test"
subnets = {
  subnet0 = { cidr_block = "10.0.1.0/24", public = true, az_index = 0 }
  subnet1 = { cidr_block = "10.0.2.0/24", public = true, az_index = 1 }
  subnet2 = { cidr_block = "10.0.3.0/24", public = false, az_index = 0 }
  subnet3 = { cidr_block = "10.0.4.0/24", public = false, az_index = 1 }
}
az_letter = "a"

# Ports / ALB
project_name      = "app"
alb_ingress_cidr  = ["0.0.0.0/0"]
alb_ingress_ports = [80, 8080]
web_backend_port  = 8080
web_ui_port       = 80

# EC2
ami           = "ami-089a7a2a13629ecc4" # Amazon Linux 2023 x86_64
instance_type = "t3.micro"
ec2_name_set  = ["react", "angular", "dotnet"]
iam_role_policies = {
  AdministratorAccess = "arn:aws:iam::aws:policy/AdministratorAccess"
  SSM                 = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# RDS / Flags
enable_rds = false
enable_alb = true
