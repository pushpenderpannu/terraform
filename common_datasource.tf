data "aws_iam_role" "history_star_ecs_task_runner_role" {
  name = var.history_star_ecs_task_runner_role
}
data "aws_iam_role" "history_star_sqs_task_event_bridge_role" {
  name = var.history_star_sqs_task_event_bridge_role
}
data "aws_ecr_image" "history_star_ecs_image" {
  repository_name = var.history_star_ecs_image_name
  image_tag = "latest"
}