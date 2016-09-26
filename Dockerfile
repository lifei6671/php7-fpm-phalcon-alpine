FROM php:7.0-fpm-alpine

MAINTAINER Minho <longfei6671@163.com>

#Alpine packages
RUN apk add --update bash 
RUN apk add freetype-dev 
RUN apk add libjpeg-turbo-dev 
RUN apk add libpng-dev 
RUN apk add libmcrypt-dev 
RUN apk add libpcre32
RUN apk add bzip2 
RUN apk add libbz2-dev 
RUN apk add libmemcached-dev 
RUN apk add bzip2 binutils 
RUN apk add ca-certificates && rm -rf /var/cache/apk/*


RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
        && docker-php-ext-install gd \
        && docker-php-ext-install mysqli \
        && docker-php-ext-install bz2 \
        && docker-php-ext-install zip \
        && docker-php-ext-install pdo \
        && docker-php-ext-install pdo_mysql \
        && docker-php-ext-install opcache
