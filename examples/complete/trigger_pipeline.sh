#!/bin/bash

# set variables
PROJECT_NAME="build"
BRANCH_NAME="main"
IMAGE_REPO_NAME=""
IMAGE_TAG=""
AWS_ACCOUNT_ID=""
AWS_DEFAULT_REGION=""

#Trigger the Codebuild project
echo "triggering AWS Codebuild for project: $PROJECT_NAME on branch: $BRANCH_NAME"

aws codebuild start-build \
  --project-name "PROJECT_NAME" \
  --source-version "BRANCH_NAME" \
  --environment-variables-override name=IMAGE_REPO_NAME,value="$IMAGE_REPO_NAME",type=PLAINTEXT \
                                   name=IMAGE_TAG,value="$IMAGE_TAG",type=PLAINTEXT \
                                   name=AWS_ACCOUNT_ID,value="$AWS_ACCOUNT_ID",type=PLAINTEXT \
                                   name=AWS_DEFAULT_REGION,value="$AWS_DEFAULT_REGION",type=PLAINTEXT \

# Confirm if succeeded
if [ $? -eq 0 ]; then
    echo "Codebuild triggered successfully"

else
    echo "Failed to trigger Codebuild"
    exit 1

fi 
