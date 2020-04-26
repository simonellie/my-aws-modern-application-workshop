#!/bin/bash

#Adding a NoSQL Database to Mythical Mysfits
aws dynamodb create-table --cli-input-json file://~/environment/aws-modern-application-workshop/module-3/aws-cli/dynamodb-table.json

#aws dynamodb describe-table --table-name MysfitsTable
#aws dynamodb scan --table-name MysfitsTable

aws dynamodb batch-write-item --request-items file://~/environment/aws-modern-application-workshop/module-3/aws-cli/populate-dynamodb.json


## after cp -R ~/environment/aws-modern-application-workshop/module-3/app/service/* ~/environment/MythicalMysfitsService-Repository/service/ for code allignment
## wait for deploy
## and update bucket with: aws s3 cp --recursive ~/environment/aws-modern-application-workshop/module-3/web/ s3://REPLACE_ME_BUCKET_NAME/

