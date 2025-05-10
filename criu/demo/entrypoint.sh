#!/bin/bash
# Run the main job in background

mkdir -p /checkpoints

cat > /tmp/test.sh <<-EOF
#!/bin/sh
while :; do
    sleep 1
    date
done
EOF
chmod +x /tmp/test.sh


if [ -n "$RESTORE" ]; then
    echo "Restoring job..."
    criu restore -d -D /checkpoints -v1
    sleep 10  # let it restore !!
    rm -rf /checkpoints/*
    echo "Restored job..." >> /tmp/test.log
    echo "Restored job..." >> /dev/stdout
    exit 0

else
    echo "Starting job..." >> /tmp/test.log
    echo "Starting job..." >> /dev/stdout

    setsid /tmp/test.sh  < /dev/null &> /tmp/test.log &
    pid=$!
    echo "Job PID: $pid"
    sleep 10
    
    echo "Dumping job..." >> /tmp/test.log
    echo "Dumping job..." >> /dev/stdout
    criu dump -t $pid -D /checkpoints -v1  && echo OK
fi