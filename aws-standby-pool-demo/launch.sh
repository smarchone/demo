#!/bin/bash

# Script to launch a new EC2 instance and poll until it's ready

DEBIAN_AMI="ami-0098d55e3c741bc7d"
AMAZ_LINUX_2_AMI="ami-03edbe403ec8522ed"

AMI_ID="$DEBIAN_AMI" # "ami-0ceb902fa839778f0"
INSTANCE_TYPE="t3.large"
KEY_NAME="hoad"
SUBNET_ID="subnet-5209d11e"
REGION="ap-south-1" 

# Launch a new instance
INSTANCE_ID=$(aws ec2 run-instances \
  --image-id "$AMI_ID" \
  --instance-type "$INSTANCE_TYPE" \
  --key-name "$KEY_NAME" \
  --security-group-ids "sg-0a4d89249f7107350" \
  --subnet-id "$SUBNET_ID" \
  --region "$REGION" \
  --no-associate-public-ip-address \
  --block-device-mappings '[{"DeviceName":"/dev/xvda","Ebs":{"VolumeSize":40}}]' \
  --query "Instances[0].InstanceId" \
  --output text)

if [ -z "$INSTANCE_ID" ]; then
  echo "Failed to launch a new instance."
  exit 1
fi

echo "Launched new instance. Instance ID: $INSTANCE_ID"

# Record the start time
START_TIME=$(date +%s)

# Poll the instance state until it's running
while true; do
  INSTANCE_STATE=$(aws ec2 describe-instances \
    --instance-ids "$INSTANCE_ID" \
    --region "$REGION" \
    --query "Reservations[0].Instances[0].State.Name" \
    --output text)

  echo "Current state: $INSTANCE_STATE"

  if [ "$INSTANCE_STATE" == "running" ]; then
    echo "Instance $INSTANCE_ID is now running."
    break
  fi

  sleep 1
  echo "Waiting for instance to be ready..."
done

END_TIME=$(date +%s)
ELAPSED_TIME=$((END_TIME - START_TIME))
echo "Instance $INSTANCE_ID has reached running state. Time elapsed: ${ELAPSED_TIME} seconds."

# Fetch the private IP of the instance
INSTANCE_PRIVATE_IP=$(aws ec2 describe-instances \
  --instance-ids "$INSTANCE_ID" \
  --region "$REGION" \
  --query "Reservations[0].Instances[0].PrivateIpAddress" \
  --output text)

if [ -z "$INSTANCE_PRIVATE_IP" ]; then
  echo "Failed to fetch the private IP of instance $INSTANCE_ID."
  exit 1
fi

# Check if the instance is reachable via SSH using the private IP
while true; do
  ssh -o StrictHostKeyChecking=no -o BatchMode=yes -o ConnectTimeout=5 -i hoad.pem ec2-user@"$INSTANCE_PRIVATE_IP" "exit" 2>/dev/null

  if [ $? -eq 0 ]; then
    END_TIME=$(date +%s)
    ELAPSED_TIME=$((END_TIME - START_TIME))
    echo "Instance $INSTANCE_ID is reachable via SSH at private IP $INSTANCE_PRIVATE_IP. Time elapsed: ${ELAPSED_TIME} seconds."
    break
  fi

  sleep 1
  echo "Waiting for instance to be reachable via SSH..."
done

echo "Instance $INSTANCE_ID is now ready and reachable via SSH at $INSTANCE_PRIVATE_IP."

