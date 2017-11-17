FROM php:7.0

LABEL MAINTAINER="Cascade"

RUN apt-get update && apt-get install -y \
    apt-utils \
    git-core \
    openssh-client \
    corkscrew \
    curl \
    libmcrypt-dev \
    libicu-dev \
    libxml2-dev libxslt1-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng12-dev \
    ocaml \
    expect \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-configure hash --with-mhash \
    && docker-php-ext-install -j$(nproc) mcrypt intl xsl gd zip pdo_mysql opcache soap bcmath json iconv \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
    # && apt-get clean && apt-get update && apt-get install -y nodejs \
    # && ln -s /usr/bin/nodejs /usr/bin/node \
    # && apt-get install -y npm \
    # && npm update -g npm && npm install -g grunt-cli && npm install -g gulp

# # PHP config
RUN echo "memory_limit=-1" > $PHP_INI_DIR/conf.d/memory-limit.ini
RUN echo "date.timezone=UTC" > $PHP_INI_DIR/conf.d/date_timezone.ini

