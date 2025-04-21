FROM php:8.1-fpm-alpine

# Install development required packages
RUN apk add --no-cache --virtual .build-deps $PHPIZE_DEPS \
    && apk add --no-cache freetype-dev libjpeg-turbo-dev libpng-dev libzip-dev bzip2-dev icu-dev imagemagick-dev curl-dev imap-dev libxml2-dev oniguruma-dev git \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd zip bz2 bcmath pdo_mysql opcache sockets intl xml curl imap mbstring \
    # Install Imagick extension
    && pecl install imagick \
    && docker-php-ext-enable imagick \
    # Install Redis extension
    && pecl install redis \
    && docker-php-ext-enable redis \
    # Remove useless package
    && apk del --no-network .build-deps

# Install composer globally
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer

# PHP ini default
ENV PHP_EXPOSE_PHP=Off
ENV PHP_MEMORY_LIMIT=256M
ENV PHP_POST_MAX_SIZE=20M
ENV PHP_UPLOAD_MAX_FILESIZE=10M
ENV PHP_MAX_FILE_UPLOADS=20
ENV PHP_MAX_INPUT_VARS=5000
ENV PHP_MAX_EXECUTION_TIME=30
ENV PHP_DISPLAY_ERRORS=1
ENV PHP_DATE_TIMEZONE=Asia/Taipei
ENV PHP_SESSION_SAVE_HANDLER=files
ENV PHP_SESSION_SAVE_PATH=/var/lib/php/sessions
ENV PHP_SESSION_COOKIE_HTTPONLY=1

# OPcache defaults
ENV PHP_OPCACHE_ENABLE=1
ENV PHP_OPCACHE_ENABLE_CLI=1
ENV PHP_OPCACHE_JIT=tracing
ENV PHP_OPCACHE_JIT_BUFFER_SIZE=256M
ENV PHP_OPCACHE_MEMORY_CONSUMPTION=128
ENV PHP_OPCACHE_INTERNED=8
ENV PHP_OPCACHE_MAX_ACCELERATED_FILES=10000
ENV PHP_OPCACHE_REVALIDATE_FREQUENCY=0
ENV PHP_OPCACHE_VALIDATE_TIMESTAMPS=0

# PHP-FPM defaults
ENV PHP_FPM_PM=dynamic
ENV PHP_FPM_MAX_CHILDREN=400
ENV PHP_FPM_START_SERVERS=100
ENV PHP_FPM_MIN_SPARE_SERVERS=80
ENV PHP_FPM_MAX_SPARE_SERVERS=120
ENV PHP_FPM_MAX_REQUESTS=1000

# Use the default development configuration
RUN mv "${PHP_INI_DIR}/php.ini-development" "${PHP_INI_DIR}/php.ini"

# Copy the Default configuration file
COPY docker/php/conf.d/php.ini "${PHP_INI_DIR}/conf.d/99-php-overwrite.ini"

# Copy the OPcache configuration file
COPY docker/php/conf.d/opcache.ini "${PHP_INI_DIR}/conf.d/98-opcache.ini"

# Copy the PHP-FPM configuration file
COPY docker/php/php-fpm.d/www.conf /usr/local/etc/php-fpm.d/www.conf

# Application root path
ENV APP_DIR=/srv/app
WORKDIR /srv/app

# Copy the PHP application file
# COPY . .

# Production Mode
# RUN composer install --no-cache --no-dev --no-scripts --prefer-dist
# Development Mode
# RUN composer install --prefer-dist

# Change Owner
# RUN chown -R www-data:www-data ${APP_DIR};
# RUN chmod -R go+rx ${APP_DIR};

# Set composer bin path
ENV PATH ${APP_DIR}/vendor/bin:${PATH}

# Development Mode - OPcache validate Enable: 1/0
ENV PHP_OPCACHE_VALIDATE_TIMESTAMPS 1

# Set memory limit
ENV PHP_MEMORY_LIMIT 1024M

# Build environment variable
ARG SHORT_SHA_ARG=fff0000
ENV SHORT_SHA ${SHORT_SHA_ARG}

ARG BUILD_TIME_ARG=19700101.000000+0000
ENV BUILD_TIME ${BUILD_TIME_ARG}
