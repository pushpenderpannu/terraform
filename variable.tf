variable "region" {
  default = "us-east-1"
}

# SQS variables
variable "history_star_source_sqs" {}
variable "history_talend_source_sqs" {}

# ECS Cluster variables
variable "history_star_ecs_cluster_name" {}

# ECS Task variables
variable "history_star_ecs_task_name" {}
variable "history_star_ecs_task_runner_role" {}
variable "history_star_ecs_cpu_size" {}
variable "history_star_ecs_memory_size" {}
variable "history_star_ecs_image_url" {}

# ECS Event bridge variables
variable "history_star_sqs_task_event_bridge_name" {}
variable "history_star_sqs_task_event_bridge_role" {}

# Cloudwatch details
variable "cw_logs_retention_in_days" {}
