[
  {
    "name": "${container_name}",
    "image": "${app_image}",
    "cpu": ${container_cpu},
    "memory": ${container_memory},
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": ${container_port}
      }
    ],
    "environment": [
      {
        "name": "AWS_REGION",
        "value": "${aws_region}"
      },
      {
        "name": "ENV_VAR_1",
        "value": "${env_var_1}"
      },
      {
        "name": "ENV_VAR_2",
        "value": "${env_var_2}"
      },
      {
        "name": "ENV_VAR_3",
        "value": "${env_var_3"
      },
      {
        "name": "ENV_VAR_4",
        "value": "${env_var_4}"
      },
      {
        "name": "ENV_VAR_5",
        "value": "${env_var_5}"
      }
    ],
    "repositoryCredentials": {
      "credentialsParameter": "${docker_hub_arn}"
    }
  }
]