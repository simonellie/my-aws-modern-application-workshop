#!/bin/bash

# Adding a User Pool for Website Users

## Create the Cognito User Pool
##############aws cognito-idp create-user-pool --pool-name MysfitsUserPool --auto-verified-attributes email > ~/environment/local/module-4/create-user-pool-output.json

## Create a Cognito User Pool Client
echo 'read UserPoolId from create-user-pool-output.json file and write here:'
read UserPoolId

##############aws cognito-idp create-user-pool-client --user-pool-id $UserPoolId --client-name MysfitsUserPoolClient > ~/environment/local/module-4/create-user-pool-client-output.json

# Adding a new REST API with Amazon API Gateway

## Create an API Gateway VPC Link
##############echo 'check for LoadBalancerArn inside of nlb-output.json and write it here:'
##############read REPLACE_ME_NLB_ARN

##############aws apigateway create-vpc-link --name MysfitsApiVpcLink --target-arns $REPLACE_ME_NLB_ARN > ~/environment/local/module-4/api-gateway-link-output.json

## Create the REST API using Swagger
cp ~/environment/aws-modern-application-workshop/module-4/aws-cli/api-swagger.json ~/environment/local/module-4/input-api-swagger.json

echo 'check for REPLACE_ME_ACCOUNT_ID inside of cloudformation-core-output.json and write it here:'
read REPLACE_ME_ACCOUNT_ID
echo 'please write region for storage (es: eu-west-1)):'
read REPLACE_ME_REGION

REPLACE_ME_COGNITO_USER_POOL_ID=$UserPoolId
echo 'check for id inside of api-gateway-link-output.json and write it here:'
read REPLACE_ME_VPC_LINK_ID
echo 'check for DNSName inside of nlb-output.json and write it here:'
read REPLACE_ME_NLB_DNS

sed -i 's|REPLACE_ME_ACCOUNT_ID|'"$REPLACE_ME_ACCOUNT_ID"'|g' ~/environment/local/module-4/input-api-swagger.json
sed -i 's|REPLACE_ME_REGION|'"$REPLACE_ME_REGION"'|g' ~/environment/local/module-4/input-api-swagger.json
sed -i 's|REPLACE_ME_COGNITO_USER_POOL_ID|'"$REPLACE_ME_COGNITO_USER_POOL_ID"'|g' ~/environment/local/module-4/input-api-swagger.json
sed -i 's|REPLACE_ME_VPC_LINK_ID|'"$REPLACE_ME_VPC_LINK_ID"'|g' ~/environment/local/module-4/input-api-swagger.json
sed -i 's|REPLACE_ME_NLB_DNS|'"$REPLACE_ME_NLB_DNS"'|g' ~/environment/local/module-4/input-api-swagger.json

aws apigateway import-rest-api --parameters endpointConfigurationTypes=REGIONAL --body file://~/environment/local/module-4/input-api-swagger.json --fail-on-warnings > ~/environment/local/module-4/import-rest-api-output.json

rm ~/environment/local/module-4/input-api-swagger.json

# Deploy the API
echo 'check for id inside of import-rest-api-output.json and write it here:'
read REPLACE_ME_WITH_API_ID

aws apigateway create-deployment --rest-api-id $REPLACE_ME_WITH_API_ID --stage-name prod > create-deployment-output.json

