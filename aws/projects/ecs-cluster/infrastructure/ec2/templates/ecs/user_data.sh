#!/bin/bash -v
#Include instance in cluster
cluster=${cluster_name}

echo ECS_CLUSTER="${cluster_name}" > /etc/ecs/ecs.config

sudo stop ecs
sudo yum update -y ecs-init
sudo start ecs

#AWS
yum install -y aws-cli jq
instance_arn=$(curl -s http://localhost:51678/v1/metadata \
  | jq -r '. | .ContainerInstanceArn' | awk -F/ '{print $NF}' )
az=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)