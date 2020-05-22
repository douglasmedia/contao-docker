FROM webdevops/php-nginx:7.4-alpine
LABEL maintainer="Robin Douglas | Douglas IT & Media <info@douglas-media.de>"

# Set it to a fix version number if you want to run a specific version
ARG CONTAO_VERSION=4.9

# add custom nginx configuration
ADD conf/vhost.conf /opt/docker/etc/nginx/vhost.conf

# copy composer install script into the container
ADD scripts/install-composer.sh /install-composer.sh

# install composer
RUN bash /install-composer.sh \
 && chown -R www-data: /app

WORKDIR /app

# Install contao
RUN COMPOSER_MEMORY_LIMIT=-1 composer create-project contao/managed-edition . $CONTAO_VERSION

# Install Contao Manager
RUN curl -o web/contao-manager.php -L https://download.contao.org/contao-manager.phar

# make sure everthing is writable. note that this is not designed for prod use.
RUN chmod -R 0777 .
RUN chown -R www-data:www-data .