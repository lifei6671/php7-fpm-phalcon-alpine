FROM daocloud.io/library/php:7.0-fpm-alpine

MAINTAINER Minho <longfei6671@163.com>

ADD conf/php.ini /usr/local/etc/php/php.ini
ADD conf/www.conf /usr/local/etc/php-fpm.d/www.conf

#Alpine packages
RUN apk add --update bash git make gcc \
	libc-dev \
	autoconf \
	freetype-dev \
	libjpeg-turbo-dev \
	libpng-dev \
	libmcrypt-dev \
	libpcre32 \
	bzip2 \
	libbz2 \
	libmemcached-dev \
	bzip2 \
	binutils \
	ca-certificates && rm -rf /var/cache/apk/*


RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
        && docker-php-ext-install gd \
        && docker-php-ext-install mysqli \
        && docker-php-ext-install bz2 \
        && docker-php-ext-install zip \
        && docker-php-ext-install pdo \
        && docker-php-ext-install pdo_mysql \
        && docker-php-ext-install opcache

		
WORKDIR /usr/src/php/ext/

RUN git clone -b php7 https://github.com/phpredis/phpredis.git \
	&& docker-php-ext-configure phpredis \
	&& docker-php-ext-install phpredis \
	&& rm -rf phpredis
	
ENV PHALCON_VERSION=3.0.1

# Compile Phalcon
RUN set -xe && \
        curl -LO https://github.com/phalcon/cphalcon/archive/v${PHALCON_VERSION}.tar.gz && \
        tar xzf v${PHALCON_VERSION}.tar.gz && cd cphalcon-${PHALCON_VERSION}/build && ./install && \
        echo "extension=phalcon.so" > /usr/local/etc/php/conf.d/phalcon.ini && \
        cd ../.. && rm -rf v${PHALCON_VERSION}.tar.gz cphalcon-${PHALCON_VERSION} 