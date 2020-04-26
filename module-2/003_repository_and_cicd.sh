#!/bin/bash

########################################
echo 'creating bucket...'

REPLACE_ME_ARTIFACTS_BUCKET_NAME=mm-artifact-esimon
echo $REPLACE_ME_ARTIFACTS_BUCKET_NAME
aws s3 mb s3://"$REPLACE_ME_ARTIFACTS_BUCKET_NAME"

echo 'replacing bucket policy...'
cp ~/environment/aws-modern-application-workshop/module-2/aws-cli/artifacts-bucket-policy.json ~/environment/local/module-2/input-artifacts-bucket-policy.json
echo 'check for REPLACE_ME_CODEBUILD_ROLE_ARN inside of cloudformation-core-output.json and write it here:'
read REPLACE_ME_CODEBUILD_ROLE_ARN
echo 'check for REPLACE_ME_CODEPIPELINE_ROLE_ARN inside of cloudformation-core-output.json and write it here:'
read REPLACE_ME_CODEPIPELINE_ROLE_ARN

sed -i 's|REPLACE_ME_CODEBUILD_ROLE_ARN|'"$REPLACE_ME_CODEBUILD_ROLE_ARN"'|g' ~/environment/local/module-2/input-artifacts-bucket-policy.json
sed -i 's|REPLACE_ME_CODEPIPELINE_ROLE_ARN|'"$REPLACE_ME_CODEPIPELINE_ROLE_ARN"'|g' ~/environment/local/module-2/input-artifacts-bucket-policy.json
sed -i 's|REPLACE_ME_ARTIFACTS_BUCKET_NAME|'"$REPLACE_ME_ARTIFACTS_BUCKET_NAME"'|g' ~/environment/local/module-2/input-artifacts-bucket-policy.json

aws s3api put-bucket-policy --bucket mm-artifact-esimon --policy file://~/environment/local/module-2/input-artifacts-bucket-policy.json

rm ~/environment/local/module-2/input-artifacts-bucket-policy.json

########################################
echo 'creating repository'
aws codecommit create-repository --repository-name MythicalMysfitsService-Repository

########################################
echo 'creating codebuild project'
cp ~/environment/aws-modern-application-workshop/module-2/aws-cli/code-build-project.json ~/environment/local/module-2/input-code-build-project.json

echo 'check for REPLACE_ME_ACCOUNT_ID inside of cloudformation-core-output.json and write it here:'
read REPLACE_ME_ACCOUNT_ID
echo 'please write region for storage (es: eu-west-1)):'
read REPLACE_ME_REGION
echo 'check for REPLACE_ME_CODEBUILD_ROLE_ARN inside of cloudformation-core-output.json and write it here:'
read REPLACE_ME_CODEBUILD_ROLE_ARN

sed -i 's|REPLACE_ME_ACCOUNT_ID|'"$REPLACE_ME_ACCOUNT_ID"'|g' ~/environment/local/module-2/input-code-build-project.json
sed -i 's|REPLACE_ME_REGION|'"$REPLACE_ME_REGION"'|g' ~/environment/local/module-2/input-code-build-project.json
sed -i 's|REPLACE_ME_CODEBUILD_ROLE_ARN|'"$REPLACE_ME_CODEBUILD_ROLE_ARN"'|g' ~/environment/local/module-2/input-code-build-project.json

aws codebuild create-project --cli-input-json file://~/environment/local/module-2/input-code-build-project.json

rm ~/environment/local/module-2/input-code-build-project.json

########################################
echo 'creating CodePipeline Pipeline'
cp ~/environment/aws-modern-application-workshop/module-2/aws-cli/code-pipeline.json ~/environment/local/module-2/input-code-pipeline.json

sed -i 's|REPLACE_ME_CODEPIPELINE_ROLE_ARN|'"$REPLACE_ME_CODEPIPELINE_ROLE_ARN"'|g' ~/environment/local/module-2/input-code-pipeline.json
sed -i 's|REPLACE_ME_ARTIFACTS_BUCKET_NAME|'"$REPLACE_ME_ARTIFACTS_BUCKET_NAME"'|g' ~/environment/local/module-2/input-code-pipeline.json

aws codepipeline create-pipeline --cli-input-json file://~/environment/local/module-2/input-code-pipeline.json

rm ~/environment/local/module-2/input-code-pipeline.json


echo 'Enable Automated Access to ECR Image Repository'

cp ~/environment/aws-modern-application-workshop/module-2/aws-cli/ecr-policy.json ~/environment/local/module-2/input-ecr-policy.json

sed -i 's|REPLACE_ME_CODEBUILD_ROLE_ARN|'"$REPLACE_ME_CODEBUILD_ROLE_ARN"'|g' ~/environment/local/module-2/input-ecr-policy.json

aws ecr set-repository-policy --repository-name mythicalmysfits/service --policy-text file://~/environment/local/module-2/input-ecr-policy.json

rm ~/environment/local/module-2/input-ecr-policy.json


#######################################
# git setup
echo 'please write user.name:'
read REPLACE_ME_WITH_YOUR_NAME
git config --global user.name "$REPLACE_ME_WITH_YOUR_NAME"

echo 'please write your email:'
read REPLACE_ME_WITH_YOUR_EMAIL
git config --global user.email $REPLACE_ME_WITH_YOUR_EMAIL

git config --global credential.helper '!aws codecommit credential-helper $@'
git config --global credential.UseHttpPath true


# git clone https://git-codecommit.eu-west-1.amazonaws.com/v1/repos/MythicalMysfitsService-Repository
