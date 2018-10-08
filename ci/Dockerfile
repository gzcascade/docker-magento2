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

ENV COMPOSER_HOME=/tmp/.composer

ENV MAGENTO_CS_VERSION=1.0.5
ENV MAGENTO_CS_PACKAGE_NAME=marketplace-eqp
ENV PATH=/home/${CLI_USER}/${MAGENTO_CS_PACKAGE_NAME}-${MAGENTO_CS_VERSION}/vendor/bin:$PATH

# add composer    
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && mkdir -p ${COMPOSER_HOME} \
    && chmod 777 ${COMPOSER_HOME} \
# add magento2 cs
    && curl -L -o /home/${CLI_USER}/${MAGENTO_CS_VERSION}.tar.gz https://github.com/magento/marketplace-eqp/archive/${MAGENTO_CS_VERSION}.tar.gz \
    && tar -zxf /home/${CLI_USER}/${MAGENTO_CS_VERSION}.tar.gz --directory /home/${CLI_USER} \
    && rm -f /home/${CLI_USER}/${MAGENTO_CS_VERSION}.tar.gz \
    && chown -R ${CLI_USER}:${CLI_GROUP} /home/${CLI_USER}/${MAGENTO_CS_PACKAGE_NAME}-${MAGENTO_CS_VERSION} \
    && su ${CLI_USER} -c "composer install -d /home/${CLI_USER}/${MAGENTO_CS_PACKAGE_NAME}-${MAGENTO_CS_VERSION}"

VOLUME ${COMPOSER_HOME}
