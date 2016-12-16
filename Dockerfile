FROM php:7.0-fpm-alpine

MAINTAINER Minho <longfei6671@163.com>

ADD conf/php.ini /usr/local/etc/php/php.ini
ADD conf/www.conf /usr/local/etc/php-fpm.d/www.conf

ENV IMAGICK_VERSION 3.4.2

#Alpine packages
RUN apk add --update git make gcc g++ \
	libc-dev \
	autoconf \
	freetype-dev \
	libjpeg-turbo-dev \
	libpng-dev \
	libmcrypt-dev \
	libpcre32 \
	bzip2 \
	libbz2 \
	bzip2-dev \
	libmemcached-dev \
	cyrus-sasl-dev \
	binutils \
	imagemagick-dev \
	&& pecl install imagick-$IMAGICK_VERSION \
	&& rm -rf /var/cache/apk/* 

RUN apk update && apk add ca-certificates && \
    apk add tzdata && \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone

RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
        && docker-php-ext-install gd \
        && docker-php-ext-install mysqli \
        && docker-php-ext-install bz2 \
        && docker-php-ext-install zip \
        && docker-php-ext-install pdo \
        && docker-php-ext-install pdo_mysql \
        && docker-php-ext-install opcache

		
WORKDIR /usr/src/php/ext/

RUN git clone -b php7-dev-playground1 https://github.com/igbinary/igbinary.git && \
	cd igbinary && phpize && ./configure CFLAGS="-O2 -g" --enable-igbinary && make install && \
	cd ../ && rm -rf igbinary
	
# Compile Memcached 
RUN git clone -b php7 https://github.com/php-memcached-dev/php-memcached.git && \
	cd php-memcached && phpize && ./configure && make && make install && \
	echo "extension=memcached.so" > /usr/local/etc/php/conf.d/phpredis.ini && \
	cd .. && rm -rf php-memcached 
	
ENV PHPREDIS_VERSION=3.0.0

RUN set -xe && \
	curl -LO https://github.com/phpredis/phpredis/archive/${PHPREDIS_VERSION}.tar.gz && \
	tar xzf ${PHPREDIS_VERSION}.tar.gz && cd phpredis-${PHPREDIS_VERSION} && phpize && ./configure --enable-redis-igbinary && make && make install && \
	echo "extension=redis.so" > /usr/local/etc/php/conf.d/phpredis.ini && \
	cd ../ && rm -rf  phpredis-${PHPREDIS_VERSION} ${PHPREDIS_VERSION}.tar.gz
	
ENV PHALCON_VERSION=3.0.2

WORKDIR /usr/src/php/ext/
# Compile Phalcon
RUN set -xe && \
    curl -LO https://github.com/phalcon/cphalcon/archive/v${PHALCON_VERSION}.tar.gz && \
    tar xzf v${PHALCON_VERSION}.tar.gz && cd cphalcon-${PHALCON_VERSION}/build && sh install && \
    echo "extension=phalcon.so" > /usr/local/etc/php/conf.d/phalcon.ini && \
    cd ../.. && rm -rf v${PHALCON_VERSION}.tar.gz cphalcon-${PHALCON_VERSION} 

#Compile XDebug
RUN set -xe && \
	curl -LO https://github.com/xdebug/xdebug/archive/XDEBUG_2_5_0.tar.gz && \
	tar xzf XDEBUG_2_5_0.tar.gz && cd xdebug-XDEBUG_2_5_0 && \
	phpize && ./configure --enable-xdebug && make && make install && \
	cd ../ && rm -rf xdebug-XDEBUG_2_5_0

RUN docker-php-source extract \
	&& cd /usr/src/php/ext/bcmath \
	&& phpize && ./configure --with-php-config=/usr/local/bin/php-config && make && make install \
	&& make clean \
	&& docker-php-source delete

	
#Delete apk
RUN apk del gcc g++ git make;