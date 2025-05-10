# Use an official CentOS as a parent image
FROM quay.io/centos/centos:stream10

# Set environment variables to avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install CRIU and other necessary packages
RUN yum update -y && \
    yum install -y criu && \
    yum clean all && rm -rf /var/cache/yum

# Set the working directory
WORKDIR /app

# Copy any necessary files into the container
COPY . /app


# Copy the entrypoint script into the container
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# Specify the entrypoint script
ENTRYPOINT ["/app/entrypoint.sh"]