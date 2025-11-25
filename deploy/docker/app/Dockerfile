FROM php:8.3-fpm-alpine

# Create non-root user with same UID/GID as your local user
ARG UID=1000
ARG GID=1000
ARG APP_ENV=production

# Set up Aliyun mirrors for Alpine
#RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && \
#    apk update && \
#    apk upgrade

# Install dependencies
RUN apk add --no-cache \
    curl \
    zip \
    unzip \
    libpng-dev \
    libzip-dev \
    libpq-dev \
    oniguruma-dev \
    gettext \
    shadow \
    $PHPIZE_DEPS

# Create non-root user
RUN groupadd --gid $GID laravel && \
    useradd --uid $UID --gid $GID --shell /bin/bash --create-home laravel

# Install PHP extensions
RUN docker-php-ext-configure gd && \
    docker-php-ext-install -j$(nproc) \
        pdo_pgsql \
        pgsql \
        mbstring \
        exif \
        pcntl \
        bcmath \
        zip \
        gd

# Install Redis extension
RUN pecl install redis && \
    docker-php-ext-enable redis

# Install Xdebug only in development
RUN if [ "$ENABLE_XDEBUG" = "true" ]; then \
        apk add --no-cache linux-headers && \
        pecl install xdebug && \
        docker-php-ext-enable xdebug && \
        echo "xdebug.mode=coverage" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini; \
    fi

# Install composer with Aliyun mirror
RUN curl -sS https://getcomposer.org/installer | php -- --version=2.8.8 --install-dir=/usr/local/bin --filename=composer && \
    composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/

WORKDIR /var/www

# Copy configuration templates
COPY ./deploy/docker/config/php/php.ini.template /usr/local/etc/php/php.ini.template

# Copy entrypoint script
COPY ./deploy/docker/app/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set proper ownership for Laravel directories only
RUN mkdir -p /var/www/storage /var/www/bootstrap/cache && \
    chown -R laravel:laravel /var/www/storage /var/www/bootstrap/cache

# Make sure the entrypoint script runs as root
USER root

EXPOSE 9000

ENTRYPOINT ["/entrypoint.sh"]
CMD ["php-fpm"]
