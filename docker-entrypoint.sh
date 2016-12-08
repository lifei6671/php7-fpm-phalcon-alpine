#!/bin/sh
set -eo pipefail

if [ ! -f /xdebug_configured ]; then
	if [ -z $XDEBUG_ENABLE ]; then
		XDEBUG_ENABLE="On" 
	fi
	if [ -z $DOCKER_HOST_IP ]; then
		DOCKER_HOST_IP="192.168.4.104"
	fi
	if [ -z $XDEBUG_PORT ]; then
		XDEBUG_PORT=9001
	fi
	if [ -z $IDEKEY ]; then
		IDEKEY="PHPSTORM"
	fi
    echo "=> Xdebug is not configured yet, configuring Xdebug ..."
	echo "zend_extension=xdebug.so" >> /usr/local/etc/php/conf.d/xdebug.ini
    echo "xdebug.remote_enable=$XDEBUG_ENABLE" >> /usr/local/etc/php/conf.d/xdebug.ini
    echo "xdebug.remote_host=$DOCKER_HOST_IP" >> /usr/local/etc/php/conf.d/xdebug.ini
    echo "xdebug.remote_port=$XDEBUG_PORT" >> /usr/local/etc/php/conf.d/xdebug.ini
    echo "xdebug.remote_connect_back=On" >> /usr/local/etc/php/conf.d/xdebug.ini
    echo "xdebug.remote_handler=dbgp" >> /usr/local/etc/php/conf.d/xdebug.ini
	echo "xdebug.remote_autostart=On" >> /usr/local/etc/php/conf.d/xdebug.ini
	echo "xdebug.profiler_enable=On" >> /usr/local/etc/php/conf.d/xdebug.ini
	echo "xdebug.idekey=$IDEKEY" >> /usr/local/etc/php/conf.d/xdebug.ini
	echo "=> Xdebug is configured."
	
    touch /xdebug_configured
else
    echo "=> Xdebug is already configured"
fi

#exec php-fpm

# first arg is `-f` or `--some-option`
# or first arg is `something.conf`
#if [ "${1#-}" != "$1" ] || [ "${1%.conf}" != "$1" ]; then
#	set -- php-fpm "$@"
#fi

#exec "$@"