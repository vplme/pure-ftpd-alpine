FROM alpine:3.22

# Install Pure-FTPd
RUN apk add pure-ftpd --no-cache

COPY entrypoint.sh /entrypoint.sh

# Expose FTP ports (21 for control, 30000-30009 for passive data)
EXPOSE 21 30000-30009

# Set entrypoint
ENTRYPOINT ["/entrypoint.sh"]
