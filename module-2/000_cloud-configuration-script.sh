#!/bin/bash

STACK_NAME="my-aws-modern-application-workshop-core-stack"

echo 'START CORE STACK CREATION named ' $STACK_NAME
aws cloudformation create-stack --stack-name $STACK_NAME --capabilities CAPABILITY_NAMED_IAM --template-body file://~/environment/local/module-2-configuration/core.yml   

echo 'WAITING FOR STACK CREATION TO BE COMPLETED...'
aws cloudformation wait stack-create-complete --stack-name $STACK_NAME && echo "stack created"

echo 'CORE STACK CREATION COMPLETED. Printing configuration description under ~/environment/local/module-2-configuration/cloudformation-core-output.json'
aws cloudformation describe-stacks --stack-name $STACK_NAME > ~/environment/local/module-2-configuration/cloudformation-core-output.json
