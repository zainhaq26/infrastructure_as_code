# ECS Cluster Variables
variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

variable "enable_container_insights" {
  description = "Enable container insights for the ECS cluster"
  type        = bool
  default     = true
}

variable "log_retention_in_days" {
  description = "Number of days to retain log events"
  type        = number
  default     = 1  # Free tier: minimal log retention
}

# ECS Task Definition Variables
variable "create_task_definition" {
  description = "Whether to create an ECS task definition"
  type        = bool
  default     = true
}

variable "task_definition_family" {
  description = "Family name for the task definition"
  type        = string
  default     = ""
}

variable "task_definition_arn" {
  description = "ARN of existing task definition to use (when create_task_definition is false)"
  type        = string
  default     = ""
}

variable "network_mode" {
  description = "Docker networking mode to use for the containers in the task"
  type        = string
  default     = "awsvpc"
}

variable "requires_compatibilities" {
  description = "Set of launch types required by the task"
  type        = list(string)
  default     = ["FARGATE"]
}

variable "cpu" {
  description = "Number of cpu units used by the task"
  type        = string
  default     = "256"  # Free tier: minimum for Fargate
}

variable "memory" {
  description = "Amount (in MiB) of memory used by the task"
  type        = string
  default     = "512"  # Free tier: minimum for Fargate
}

variable "container_definitions" {
  description = "JSON string of container definitions"
  type        = string
  default     = ""
}

variable "volumes" {
  description = "List of volume definitions"
  type = list(object({
    name = string
    efs_volume_configuration = optional(object({
      file_system_id          = string
      root_directory          = optional(string)
      transit_encryption      = optional(string)
      transit_encryption_port = optional(number)
      authorization_config = optional(object({
        access_point_id = optional(string)
        iam             = optional(string)
      }))
    }))
  }))
  default = []
}

# ECS Service Variables
variable "create_service" {
  description = "Whether to create an ECS service"
  type        = bool
  default     = true
}

variable "service_name" {
  description = "Name of the ECS service"
  type        = string
  default     = ""
}

variable "desired_count" {
  description = "Number of instances of the task definition to place and keep running"
  type        = number
  default     = 1  # Free tier: minimal instances
}

variable "launch_type" {
  description = "Launch type on which to run your service"
  type        = string
  default     = "FARGATE"
}

variable "network_configuration" {
  description = "Network configuration for the service"
  type = object({
    subnets          = list(string)
    security_groups  = optional(list(string))
    assign_public_ip = optional(bool)
  })
  default = null
}

variable "load_balancer_config" {
  description = "Load balancer configuration for the service"
  type = object({
    target_group_arn = string
    container_name   = string
    container_port   = number
  })
  default = null
}

variable "service_registries" {
  description = "Service discovery registries for the service"
  type = list(object({
    registry_arn = string
  }))
  default = []
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}
