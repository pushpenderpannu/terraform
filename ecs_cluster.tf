resource "aws_sqs_queue" "star_input" {
  name = var.history_star_source_sqs
}

resource "aws_sqs_queue" "talend_input" {
  name = var.history_talend_source_sqs
}


resource "aws_ecs_cluster" "history_cluster" {
  depends_on = [aws_cloudwatch_log_group.history_cluster_cloudwatch]
  name       = var.history_star_ecs_cluster_name
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_cloudwatch_log_group" "history_cluster_cloudwatch" {
  name              = "/aws/ecs/${var.history_star_ecs_cluster_name}"
  retention_in_days = var.cw_logs_retention_in_days
}

resource "aws_ecs_task_definition" "history_star_task" {
  execution_role_arn       = data.aws_iam_role.history_star_ecs_task_runner_role.arn
  task_role_arn            = data.aws_iam_role.history_star_ecs_task_runner_role.arn
  depends_on               = [aws_ecs_cluster.history_cluster, aws_cloudwatch_log_group.history_star_ecs_task_cwlog]
  family                   = var.history_star_ecs_task_name
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  memory                   = var.history_star_ecs_memory_size
  cpu                      = var.history_star_ecs_cpu_size
  container_definitions    = jsonencode([
    {
      name         = "${var.history_star_ecs_task_name}-container"
      image        = data.aws_ecr_image.history_star_ecs_image.image_uri
      essential    = true
      skip_destroy = true
      environment  = [
        {
          "name" : "start_date",
          "value" : "01-01-1991"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options   = {
          "awslogs-group"         = "/aws/ecs/${var.history_star_ecs_task_name}"
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "ecs"

        }
      }
    }

  ])

}

resource "aws_cloudwatch_log_group" "history_star_ecs_task_cwlog" {
  name              = "/aws/ecs/${var.history_star_ecs_task_name}"
  retention_in_days = var.cw_logs_retention_in_days
}


resource "aws_pipes_pipe" "history_star_sqs_task_event_bridge" {
  depends_on = [
    aws_cloudwatch_log_group.history_star_sqs_task_event_bridge_log_group,
    aws_sqs_queue.star_input,
    aws_ecs_task_definition.history_star_task
  ]
  name          = var.history_star_sqs_task_event_bridge_name
  role_arn      = data.aws_iam_role.history_star_sqs_task_event_bridge_role.arn
  desired_state = "RUNNING"


  source = aws_sqs_queue.star_input.arn

  source_parameters {
    sqs_queue_parameters {
      batch_size = 1
    }
  }

  target = aws_ecs_cluster.history_cluster.arn
  target_parameters {
    ecs_task_parameters {

      task_definition_arn     = aws_ecs_task_definition.history_star_task.arn
      task_count              = 1
      enable_ecs_managed_tags = true
      enable_execute_command  = false
      launch_type             = "FARGATE"

      overrides {
        container_override {
          name               = "${var.history_star_ecs_task_name}-container"
          cpu                = var.history_star_ecs_cpu_size
          memory             = var.history_star_ecs_memory_size
          memory_reservation = var.history_star_ecs_memory_size
          environment {
            name  = "start_date"
            value = "$.start_date" // Extract start_date from SQS message
          }
        }

      }


      network_configuration {
        aws_vpc_configuration {
          subnets = var.history_star_ecs_subnets
#          security_groups = var.history_star_ecs_security_group
        }
      }
    }
  }

  log_configuration {
    cloudwatch_logs_log_destination {
      log_group_arn = aws_cloudwatch_log_group.history_star_sqs_task_event_bridge_log_group.arn
    }
    level = "ERROR"
  }


}
resource "aws_cloudwatch_log_group" "history_star_sqs_task_event_bridge_log_group" {
  name              = "/aws/vendedlogs/pipes/${var.history_star_sqs_task_event_bridge_name}"
  retention_in_days = var.cw_logs_retention_in_days
}
