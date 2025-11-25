FROM nginx:1.29-alpine

# Set up Aliyun mirrors for Alpine
#RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && \
#    apk update && \
#    apk upgrade

# Install dependencies
RUN apk add --no-cache \
    bash \
    curl \
    gettext

# Copy Nginx configuration templates
COPY ./deploy/docker/nginx/templates /etc/nginx/templates/

# Set working directory
WORKDIR /var/www

# Copy healthcheck script
COPY ./deploy/docker/nginx/healthcheck.sh /healthcheck.sh
RUN chmod +x /healthcheck.sh

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD /healthcheck.sh

# Expose port
EXPOSE 80
