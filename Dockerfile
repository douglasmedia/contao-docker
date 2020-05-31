FROM php:7.4-fpm-alpine
LABEL maintainer="Robin Douglas | Douglas IT & Media <info@douglas-media.de>"

# install required php extensions
RUN set -eux; \
	\
	apk add --no-cache --virtual .build-deps \
		coreutils \
		freetype-dev \
		libjpeg-turbo-dev \
		libpng-dev \
		libzip-dev \
        libwebp-dev \
		icu-dev \
		postgresql-dev \
	; \
	\
    docker-php-ext-configure gd \
		--with-freetype=/usr/include \
		--with-jpeg=/usr/include \
	; \
	\
	docker-php-ext-install -j "$(nproc)" \
		gd \
		opcache \
		pdo_mysql \
		pdo_pgsql \
		zip \
		intl \
        exif \
	; \
	\
	runDeps="$( \
		scanelf --needed --nobanner --format '%n#p' --recursive /usr/local \
			| tr ',' '\n' \
			| sort -u \
			| awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
	)"; \
	apk add --virtual .drupal-phpexts-rundeps $runDeps; \
	apk del .build-deps

# Use the default production configuration
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set it to a fix version number if you want to run a specific version
ARG CONTAO_VERSION=4.9

WORKDIR /var/www/html

# Install contao
RUN COMPOSER_MEMORY_LIMIT=-1 composer create-project contao/managed-edition . $CONTAO_VERSION

# make sure that user www-data has access to contao
RUN chown -R www-data:www-data /var/www/html

# Expose volumes
VOLUME ["/var/www/html", "/var/www/html/assets", "/var/www/html/files", "/var/www/html/templates", "/var/www/html/system/modules"]
