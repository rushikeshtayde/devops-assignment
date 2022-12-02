provider "aws" {
  version = "~> 2.0"
  region  = "eu-west-1"
}


data "aws_iam_role" "task_ecs" {
  name = "ecsTaskExecutionRole"
}

data "aws_vpc" "default_vpc" {
  default = true
}

data "aws_subnet_ids" "subnets" {
  vpc_id = data.aws_vpc.default_vpc.id
  availability_zone= "eu-west-2a"
}


resource "aws_ecs_cluster" "cluster" {
  name = "Flaskapp"
}

resource "aws_ecs_task_definition" "definition" {
  family                   = "flaskapp"
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  execution_role_arn       = data.aws_iam_role.task_ecs.arn
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "1024"
  requires_compatibilities = ["FARGATE"]

  container_definitions = <<TASK_DEFINITION
[
  {
    "image": " 303981612052.dkr.ecr.eu-west-2.amazonaws.com/docker-registry:latest",
    "name": "flaskapp-container",
    "logConfiguration": {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-region" : "eu-west-2",
                    "awslogs-group" : "stream-to-log-fluentd",
                    "awslogs-stream-prefix" : "flaskapp"
                }
            },

    "environment": [
            {
                "name": "Flaskapp",
                "value": "hello"
            }
        ]
    }

]
TASK_DEFINITION
}
