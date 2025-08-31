#!/bin/sh

# Default values
FTP_USER=${FTP_USER:-ftpuser}
FTP_PASSWORD=${FTP_PASSWORD:-ftppass}
PASSIVE_PORTS=${PASSIVE_PORTS:-30000:30009}
PASSIVE_IP=${PASSIVE_IP:-}

echo "Setting up Pure-FTPd..."

# Create FTP user if it doesn't exist
if ! id "$FTP_USER" >/dev/null 2>&1; then
    adduser -D -h /data -s /bin/sh $FTP_USER
    echo "$FTP_USER:$FTP_PASSWORD" | chpasswd
    echo "Created user: $FTP_USER"
fi

# Create data directory
mkdir -p /data
chown $FTP_USER:$FTP_USER /data

echo "Starting Pure-FTPd in passive mode..."
echo "Passive ports: $PASSIVE_PORTS"

# Build Pure-FTPd command
ARGS="-p $PASSIVE_PORTS -d -j -4 -l unix -A"

# Add passive IP if specified
if [ -n "$PASSIVE_IP" ]; then
    ARGS="$ARGS -P $PASSIVE_IP"
    echo "Passive IP: $PASSIVE_IP"
fi

# Start Pure-FTPd with simple passive mode configuration
exec /usr/sbin/pure-ftpd $ARGS
