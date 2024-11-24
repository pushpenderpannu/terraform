region = "us-east-1"

# SQS variables
history_star_source_sqs   = "history_star_input_queue"
history_talend_source_sqs = "history_talend_input_queue"

# ECS Cluster variables
history_star_ecs_cluster_name = "history_cluster"

# ECS Task variables
history_star_ecs_task_name        = "history_star_task"
history_star_ecs_task_runner_role = "ecsTaskExecutionRole"
history_star_ecs_cpu_size         = 1024
history_star_ecs_memory_size      = 2048
history_star_ecs_image_name       = "star/first_app"
history_star_ecs_subnets          = [
  "subnet-08887be2b87d35d58", "subnet-037262bf2457f8973", "subnet-027054b7820cd5f9f",
  "subnet-005f0c3685c0ecebf", "subnet-022e0e607bee2b3a4", "subnet-0817c50fda8b7c9fd"
]
history_star_ecs_security_group = ["sg-0b1901ce20dbf9a70"]

# ECS Event bridge variables
history_star_sqs_task_event_bridge_name = "history_sqs_event_bridge"
history_star_sqs_task_event_bridge_role = "Amazon_EventBridge_Pipe_Execution_30d8668a"

# Cloudwatch details
cw_logs_retention_in_days = 30
