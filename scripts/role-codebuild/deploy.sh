#!/usr/bin/env bash

function stack_creation(){
    STACK_NAME=$1
    if [ -z "$1" ]
    then
        echo "No STACK_NAME argument supplied"
        exit 1
    fi
    echo $DIR
    echo "Creating stack..."
    echo ${STACK_NAME}
    # echo ${DIR}
    STACK_ID=$( \
    aws cloudformation create-stack \
    --stack-name $1 \
    --template-body file://$DIR/$2 \
    --capabilities CAPABILITY_NAMED_IAM \
    --parameters file://$DIR/parameters.json \
    --tags file://$DIR/tags.json \
    --region $3
    # | jq -r .StackId \
    )
    echo "Waiting on ${STACK_ID} create completion..."
    aws cloudformation wait stack-create-complete --stack-name ${STACK_ID}
    aws cloudformation describe-stacks --stack-name ${STACK_ID} 
    # | jq .Stacks[0].Outputs
}

stack_creation ec2InstanceProfile ec2InstanceProfile.yaml us-east-1 