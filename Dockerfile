FROM php:7.0-fpm-alpine

MAINTAINER Minho <longfei6671@163.com>
RUN echo "http://mirrors.aliyun.com/alpine/v3.4/main" > /etc/apk/repositories \
	&& echo "http://mirrors.aliyun.com/alpine/v3.4/community" >> /etc/apk/repositories

#Alpine packages
RUN apk add --update .phpize-deps 
RUN apk add .build-deps
	
RUN apk add --update bash freetype-dev libjpeg-turbo-dev libpng-dev libmcrypt-dev libpcre3-dev bzip2 libbz2-dev libmemcached-dev bzip2 binutils ca-certificates && rm -rf /var/cache/apk/*


RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
        && docker-php-ext-install gd \
        && docker-php-ext-install mysqli \
        && docker-php-ext-install bz2 \
        && docker-php-ext-install zip \
        && docker-php-ext-install pdo \
        && docker-php-ext-install pdo_mysql \
        && docker-php-ext-install opcache
