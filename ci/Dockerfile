FROM php:7.0.20-cli

LABEL maintainer="Cascade <dev@cascade.com>"

# add gosu
COPY --from=gzcascade/gosu /usr/local/bin/gosu /usr/local/bin/gosu

ENV CLI_USER=ci-user
ENV CLI_GROUP=ci-user

RUN set -xe \
# add cl user
    && groupadd -g 1000 ${CLI_GROUP} \
    && useradd -u 1000 -m -d /home/${CLI_USER} -g ${CLI_GROUP} ${CLI_USER} \
    && apt-get update && apt-get install -y --no-install-recommends \
        curl \
        git \
        unzip \
        libmcrypt-dev \
        libicu-dev \
        libxml2-dev libxslt1-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng12-dev \
        openssh-client \
        rsync \
        mysql-client \
        sshpass \
    && rm -r /var/lib/apt/lists/* \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-configure hash --with-mhash \
    && docker-php-ext-install -j$(nproc) mcrypt intl xsl gd zip pdo_mysql opcache soap bcmath json iconv \
    && pecl install redis && docker-php-ext-enable redis \
    && pecl install xdebug \
    && echo "xdebug.max_nesting_level=1000" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && chmod 666 /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && rm -rf /tmp/*

ENV COMPOSER_HOME=/home/${CLI_USER}/.composer
# add composer    
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

ENV MAGENTO_CS_VERSION=1.0.5
ENV MAGENTO_CS_PACKAGE_NAME=marketplace-eqp
ENV PATH=/home/${CLI_USER}/${MAGENTO_CS_PACKAGE_NAME}-${MAGENTO_CS_VERSION}/vendor/bin:$PATH
# add magento2 cs
RUN gosu ${CLI_USER} curl -sSL https://github.com/magento/marketplace-eqp/archive/${MAGENTO_CS_VERSION}.tar.gz \
    | gosu ${CLI_USER} tar -zx --directory /home/${CLI_USER} \
    && gosu ${CLI_USER} composer install -d /home/${CLI_USER}/${MAGENTO_CS_PACKAGE_NAME}-${MAGENTO_CS_VERSION}

ENV DOCKERIZE_VERSION=v0.6.1
RUN curl -sSL https://github.com/jwilder/dockerize/releases/download/${DOCKERIZE_VERSION}/dockerize-linux-amd64-${DOCKERIZE_VERSION}.tar.gz \
    | tar xz -C /usr/local/bin
