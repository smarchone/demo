
# Usage: ./stop.sh <instance-id>
# Example: ./stop.sh i-0abcd1234efgh5678
#
# Check if the instance ID is provided          \
if [ -z "$1" ]; then
  echo "Usage: $0 <instance-id>"
  exit 1
fi
INSTANCE_ID="$1"
REGION="ap-south-1"  # Change this to your desired region
# Check if the instance ID is valid
if ! [[ "$INSTANCE_ID" =~ ^i-[0-9a-f]{8,17}$ ]]; then
  echo "Invalid instance ID format. Please provide a valid instance ID."
  exit 1
fi
# Stop the instance
echo "Stopping instance $INSTANCE_ID..."
aws ec2 stop-instances --instance-ids "$INSTANCE_ID" --region "$REGION" # --hibernate
if [ $? -ne 0 ]; then
  echo "Failed to stop instance $INSTANCE_ID."
  exit 1
fi
# Record the stop time
STOP_TIME=$(date +%s)
echo "Instance $INSTANCE_ID is stopping... $STOP_TIME"
# Poll the instance state until it's stopped
while true; do
  INSTANCE_STATE=$(aws ec2 describe-instances \
    --instance-ids "$INSTANCE_ID" \
    --region "$REGION" \
    --query "Reservations[0].Instances[0].State.Name" \
    --output text)
  
  echo "Current state: $INSTANCE_STATE"
  
  if [ "$INSTANCE_STATE" == "stopped" ]; then
    echo "Instance $INSTANCE_ID is now stopped."
    break
  fi
  
  sleep 1
  echo "Waiting for instance to be stopped..."
done

# time elapsed
END_TIME=$(date +%s)
ELAPSED_TIME=$((END_TIME - STOP_TIME))
echo "Instance $INSTANCE_ID has been stopped. Time elapsed: ${ELAPSED_TIME} seconds."