FROM alpine:3.8

RUN addgroup -g 1000 -S www-data \
 && adduser -u 1000 -D -S -G www-data www-data

# on alpine static compiled patched qt headless wkhtmltopdf (47.2 MB)
# compilation takes 4 hours on EC2 m1.large in 2016 thats why binary

RUN apk update && apk upgrade

# Install packages
RUN apk --no-cache add \
    curl \
    nginx \
    php7 \
    php7-ctype \
    php7-curl \
    php7-dom \
    php7-fpm \
    php7-json \
    php7-intl \
    php7-mbstring \
    php7-openssl \
    php7-phar \
    php7-xml \
    php7-xmlreader \
    php7-simplexml \
    php7-zlib \
    php7-gd \
    php7-pdo \
    php7-mysqli \
    php7-pdo_mysql \
    php7-xdebug \
    php7-session  \
    php7-dev \
    php7-tokenizer \
    php7-xmlwriter \
    php7-intl \
    mongodb \
    supervisor \
    xvfb \
    ttf-freefont \
    fontconfig \
    dbus \
    openssl \
    git

ADD docker/nginx/local/nginx.conf /etc/nginx/
ADD docker/nginx/local/auto-de.conf /etc/nginx/conf.d/
ADD docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ADD docker/php7-fpm/zz-www.conf /etc/php7/
ADD docker/php7-fpm/www.conf /etc/php7/
ADD docker/php7-fpm/php.ini /etc/php7/php.ini

WORKDIR /var/www/project

RUN mkdir -p /var/www/project/logs
RUN mkdir -p /var/www/project/tmp/cache

RUN chmod 777 -R /var/www/project/logs
RUN chmod 777 -R /var/www/project/tmp/cache

RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

RUN echo "upstream php-upstream { server 127.0.0.1:9000; }" > /etc/nginx/conf.d/upstream.conf

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]