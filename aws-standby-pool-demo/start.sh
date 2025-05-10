#!/bin/bash

# Script to start an EC2 instance and poll until it's ready

INSTANCE_ID=$1
REGION="ap-south-1" # Change to your desired region

if [ -z "$INSTANCE_ID" ]; then
  echo "Usage: $0 <instance-id>"
  exit 1
fi

# Start the instance and print the result
echo "Starting instance $INSTANCE_ID..."
aws ec2 start-instances --instance-ids "$INSTANCE_ID" --region "$REGION" --output text

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
echo "Instance $INSTANCE_ID has reached running state .Time elapsed: ${ELAPSED_TIME} seconds."

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
echo "trying to ssh into Private IP of instance $INSTANCE_ID: $INSTANCE_PRIVATE_IP"
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