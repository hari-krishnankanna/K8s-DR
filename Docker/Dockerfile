# the official WordPress image as the base image
FROM wordpress:6.2.1-apache

# Update package list and install stress-ng
RUN apt-get update && \
    apt-get install -y stress-ng && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Expose the default port
EXPOSE 80

# Start the Apache server in the foreground
CMD ["apache2-foreground"]

