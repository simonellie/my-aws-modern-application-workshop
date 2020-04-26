#!/bin/bash

# Service Prerequisites in Amazon ECS

## Create an ECS Cluster
aws ecs create-cluster --cluster-name MythicalMysfits-Cluster
## Create an AWS CloudWatch Logs Group
aws logs create-log-group --log-group-name mythicalmysfits-logs

## Register an ECS Task Definition
aws ecs register-task-definition --cli-input-json file://~/environment/local/module-2-configuration/task-definition.json

## Create a Network Load Balancer
echo 'check for REPLACE_ME_PUBLIC_SUBNET_ONE inside of cloudformation-core-output.json and write it here:'
read REPLACE_ME_PUBLIC_SUBNET_ONE
echo 'check for REPLACE_ME_PUBLIC_SUBNET_TWO inside of cloudformation-core-output.json and write it here:'
read REPLACE_ME_PUBLIC_SUBNET_TWO

aws elbv2 create-load-balancer --name mysfits2-nlb --scheme internet-facing --type network --subnets $REPLACE_ME_PUBLIC_SUBNET_ONE $REPLACE_ME_PUBLIC_SUBNET_TWO > ~/environment/local/module-2-configuration/nlb-output.json


## Create a Load Balancer Target Group
echo 'check for VpcId inside of nlb-output.json and write it here:'
read REPLACE_ME_VPC_ID

aws elbv2 create-target-group --name MythicalMysfits2-TargetGroup --port 8080 --protocol TCP --target-type ip --vpc-id $REPLACE_ME_VPC_ID --health-check-interval-seconds 10 --health-check-path / --health-check-protocol HTTP --healthy-threshold-count 3 --unhealthy-threshold-count 3 > ~/environment/local/module-2-configuration/target-group-output.json

## Create a Load Balancer Listener
echo 'check for TargetGroupArn inside of target-group-output.json and write it here:'
read REPLACE_ME_NLB_TARGET_GROUP_ARN
echo 'check for LoadBalancerArn inside of nlb-output.json and write it here:'
read REPLACE_ME_NLB_ARN

aws elbv2 create-listener --default-actions TargetGroupArn=$REPLACE_ME_NLB_TARGET_GROUP_ARN,Type=forward --load-balancer-arn $REPLACE_ME_NLB_ARN --port 80 --protocol TCP

## Creating a Service Linked Role for ECS
aws iam create-service-linked-role --aws-service-name ecs.amazonaws.com

## Create the Service
cp ~/environment/local/module-2-configuration/service-definition.json ~/environment/local/module-2-configuration/input-service-definition.json
echo 'check for REPLACE_ME_SECURITY_GROUP_ID inside of cloudformation-core-output.json and write it here:'
read REPLACE_ME_SECURITY_GROUP_ID
echo 'check for REPLACE_ME_PRIVATE_SUBNET_ONE inside of cloudformation-core-output.json and write it here:'
read REPLACE_ME_PRIVATE_SUBNET_ONE
echo 'check for REPLACE_ME_PRIVATE_SUBNET_TWO inside of cloudformation-core-output.json and write it here:'
read REPLACE_ME_PRIVATE_SUBNET_TWO

sed -i 's|REPLACE_ME_SECURITY_GROUP_ID|'"$REPLACE_ME_SECURITY_GROUP_ID"'|g' ~/environment/local/module-2-configuration/input-service-definition.json
sed -i 's|REPLACE_ME_PRIVATE_SUBNET_ONE|'"$REPLACE_ME_PRIVATE_SUBNET_ONE"'|g' ~/environment/local/module-2-configuration/input-service-definition.json
sed -i 's|REPLACE_ME_PRIVATE_SUBNET_TWO|'"$REPLACE_ME_PRIVATE_SUBNET_TWO"'|g' ~/environment/local/module-2-configuration/input-service-definition.json
sed -i 's|REPLACE_ME_NLB_TARGET_GROUP_ARN|'"$REPLACE_ME_NLB_TARGET_GROUP_ARN"'|g' ~/environment/local/module-2-configuration/input-service-definition.json
 
aws ecs create-service --cli-input-json file://~/environment/local/module-2-configuration/input-service-definition.json

rm ~/environment/local/module-2-configuration/input-service-definition.json

