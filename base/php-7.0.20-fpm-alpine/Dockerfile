FROM php:7.0.20-fpm-alpine

LABEL maintainer="Cascade <dev@cascade.com>"

ENV PHP_EXTRA_CONFIGURE_ARGS="--enable-fpm --with-fpm-user=www-data --with-fpm-group=www-data"
ENV PHPREDIS_VERSION 3.1.2
ENV PHPAPCU_VERSION 5.1.12

RUN set -xe \
# change to aliyun repository
        && sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
        && apk --no-cache add bash curl git vim \
        \
# add php-ext redis
        && mkdir -p /usr/src/php/ext/redis \
        && curl -L https://github.com/phpredis/phpredis/archive/$PHPREDIS_VERSION.tar.gz | tar xz -C /usr/src/php/ext/redis --strip 1 \
        && echo 'redis' >> /usr/src/php-available-exts \
# add php-ext apcu        
        && mkdir -p /usr/src/php/ext/apcu \
        && curl -L http://pecl.php.net/get/apcu-$PHPAPCU_VERSION.tgz | tar xz -C /usr/src/php/ext/apcu --strip 1 \
        && echo 'apcu' >> /usr/src/php-available-exts \
# add php-ext deps
        && apk add --update --no-cache --virtual .build-deps zlib-dev libmcrypt-dev icu-dev libxml2-dev libxslt-dev freetype-dev libjpeg-turbo-dev libpng-dev \
        && /bin/bash -lc "\
            docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/ ; \
            docker-php-ext-configure hash --with-mhash ; \
            docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) mcrypt intl xsl gd zip pdo_mysql opcache soap bcmath json iconv redis apcu ;" \
        && runDeps="$( \
            scanelf --needed --nobanner --format '%n#p' --recursive /usr/local/lib/php/extensions \
            | tr ',' '\n' \
            | sort -u \
            | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
            )" \
        && apk add --no-cache --virtual .phpext-rundeps $runDeps \
        && apk del .build-deps \
        && docker-php-source delete \
        && rm -rf /var/cache/apk/* \
        && rm -rf /tmp/*
