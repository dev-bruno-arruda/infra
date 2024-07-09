#!/bin/bash
#Adicionar este script como source em ~/.bashrc
AWS_SECRET_ID1="stage/DB_USER"
AWS_SECRET_ID2="stage/DB_NAME"
AWS_SECRET_ID3="stage/DB_PASSWORD"
AWS_SECRET_ID4="stage/DB_HOST"
AWS_REGION="us-east-1"
DB_USER=""
DB_NAME=""
DB_PASSWORD=""
DB_HOST=""

# Ensure your EC2 instance has the most recent version of the AWS CLI
yum install -y python3-pip jq
#apt-get install -y jq
pip3 install awscli --upgrade

# Export the secret to environment variables
DB_USER=$(aws secretsmanager get-secret-value --secret-id $AWS_SECRET_ID1 --region $AWS_REGION | jq --raw-output '.SecretString' | jq -r .DB_USER)
# echo $DB_USER
DB_NAME=$(aws secretsmanager get-secret-value --secret-id $AWS_SECRET_ID2 --region $AWS_REGION | jq --raw-output '.SecretString' | jq -r .DB_NAME)
#echo $DB_NAME
DB_PASSWORD=$(aws secretsmanager get-secret-value --secret-id $AWS_SECRET_ID3 --region $AWS_REGION | jq --raw-output '.SecretString' | jq -r .DB_PASSWORD)
# echo $DB_PASSWORD
DB_HOST=$(aws secretsmanager get-secret-value --secret-id $AWS_SECRET_ID4 --region $AWS_REGION | jq --raw-output '.SecretString' | jq -r .DB_HOST)
# echo $DB_HOST