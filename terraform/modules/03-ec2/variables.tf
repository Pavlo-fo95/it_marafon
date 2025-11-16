variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

# ---------------- EC2 ----------------

variable "ami" {
  description = "ID of AMI to use for the instance"
  type        = string
}

variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address with an instance in a VPC"
  type        = bool
  default     = true
}

variable "availability_zone" {
  description = "AZ to start the instance in"
  type        = string
  default     = null
}

variable "iam_instance_profile" {
  description = "Existing IAM Instance Profile name (if create_iam_instance_profile = false)"
  type        = string
  default     = null
}

variable "instance_type" {
  description = "The type of instance to start"
  type        = string
}

variable "ec2_name" {
  description = "Name to be used on EC2 instance created"
  type        = string
}

variable "sgs" {
  description = "Security Groups ids"
  type        = list(string)
}

variable "subnet" {
  description = "Subnet id"
  type        = string
}

# ---------------- IAM role ----------------

variable "create_iam_instance_profile" {
  description = "Create IAM instance profile"
  type        = bool
  default     = false
}

variable "iam_role_name" {
  description = "Name to use on IAM role created"
  type        = string
  default     = null
}

variable "iam_role_use_name_prefix" {
  description = "Use name as prefix for IAM role"
  type        = bool
  default     = true
}

variable "iam_role_path" {
  description = "IAM role path"
  type        = string
  default     = null
}

variable "iam_role_description" {
  description = "Description of the role"
  type        = string
  default     = null
}

variable "iam_role_permissions_boundary" {
  description = "ARN of permissions boundary policy"
  type        = string
  default     = null
}

variable "iam_role_tags" {
  description = "Additional tags for IAM role/profile"
  type        = map(string)
  default     = {}
}

variable "iam_role_policies" {
  description = "Policies attached to the IAM role"
  type        = map(string)
  default     = {}
}

# ---------------- Ports / TG ----------------

variable "web_ui_port" {
  description = "Port for Web UI service (host + target group)"
  type        = number
}

variable "web_backend_port" {
  description = "Port for backend service (host + target group)"
  type        = number
}

variable "port" {
  description = "Port used in target group attachment/health checks"
  type        = number
}

variable "target_group_arn" {
  description = "ARN of the target group to attach the instance to"
  type        = string
  default     = null
}

# ---------------- Docker images ----------------

variable "docker_backend_image" {
  description = "Backend Docker image (e.g. pavlovaalla88/secret-nick-api:0.1.3)"
  type        = string
  default     = ""
}

variable "docker_front_image" {
  description = "Frontend Docker image (e.g. pavlovaalla88/secret-nick-front:0.1.3)"
  type        = string
  default     = ""
}
