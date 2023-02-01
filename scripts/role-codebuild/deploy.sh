#!/usr/bin/env bash

sudo yum install jq
function stack_creation(){
    STACK_NAME=$1
    if [ -z "$1" ]
    then
        echo "No STACK_NAME argument supplied"
        exit 1
    fi

    echo "Creating Stack..."
    echo ${STACK_NAME}
    echo ${DIR}
    echo file://${DIR}/tags.json
    echo file://${DIR}/$2
    echo file://$DIR/parameters.json
    STACK_ID=$( \
    aws cloudformation create-stack \
    --stack-name $1 \
    --template-body file://${DIR}/$2 \
    --capabilities CAPABILITY_NAMED_IAM \
    --parameters file://$DIR/parameters.json \
    --tags file://${DIR}/tags.json \
    --region $3
    # | jq -r .StackId \
    )
    echo "Waiting on ${STACK_NAME} create completion..."
    aws cloudformation wait stack-create-complete --stack-name ${STACK_NAME} --region $3
    # aws cloudformation describe-stacks --stack-name ${STACK_NAME} --region $3
}

stack_creation ec2InstanceProfile ec2InstanceProfile.yaml us-east-1
stack_creation codebuild codebuild.yaml us-east-1
stack_creation ecs-execution ecs-execution.yaml us-east-1
stack_creation ecs-task-execution ecs-task-execution.yaml us-east-1 