FROM php:7.0.20-cli

LABEL maintainer="Cascade <dev@cascade.com>"

# add gosu
COPY --from=gzcascade/gosu /usr/local/bin/gosu /usr/local/bin/gosu

ENV CLI_USER=ci-user
ENV CLI_GROUP=ci-user

RUN set -xe \
# add cl user
    && groupadd -g 1000 ${CLI_GROUP} \
    && useradd -u 1000 -g ${CLI_GROUP} ${CLI_USER} \
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

# add composer    
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && mkdir -p ${COMPOSER_HOME} \
    && chmod 777 ${COMPOSER_HOME}

VOLUME ${COMPOSER_HOME}