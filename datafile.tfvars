region = "us-east-1"

# SQS variables
history_star_source_sqs = "history_star_input_queue"
history_talend_source_sqs = "history_talend_input_queue"

# ECS Cluster variables
history_star_ecs_cluster_name = "history_cluster"

# ECS Task variables
history_star_ecs_task_name = "history_star_task"
history_star_ecs_task_runner_role = "history_star_ecs_role"
history_star_ecs_cpu_size = 1024
history_star_ecs_memory_size = 2048
history_star_ecs_image_url = "632045202123.dkr.ecr.us-east-1.amazonaws.com/star/first_app"

# ECS Event bridge variables
history_star_sqs_task_event_bridge_name = "history_sqs_event_bridge"
history_star_sqs_task_event_bridge_role = ""

# Cloudwatch details
cw_logs_retention_in_days = 30
