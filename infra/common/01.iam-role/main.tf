// ---- END: ecsInstanceRole ----
resource "aws_iam_role" "ecs_instance_role" {
  name = "${var.environment}-ecsInstanceRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_instance_role_policy" {
  role       = aws_iam_role.ecs_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "${var.environment}-ecsInstanceProfile"
  role = aws_iam_role.ecs_instance_role.name
}
// ---- END: ecsInstanceRole ----


// ---- START: ecsTaskExecutionRole ----
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.environment}-ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_policy" "ecs_task_execution_logs_policy" {
  name        = "${var.environment}-EcsTaskExecutionLogsPolicy"
  description = "Allow ECS Task Execution Role to describe CloudWatch log groups"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ],
        "Resource" : [
          "arn:aws:logs:*:*:*"
        ]
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "ecs_task_execution_logs_attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.ecs_task_execution_logs_policy.arn
}
// ---- END: ecsTaskExecutionRole ----
