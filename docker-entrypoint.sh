#!/bin/sh
set -eo pipefail

if [ ! -z $tracker_server ] ; then
	mkdir -p /tmp/fastdfs
	sed -i 's/^tracker_server.*/tracker_server='$tracker_server'/g' /etc/fdfs/client.conf
	sed -i 's#^base_path=.*#base_path=/tmp/fastdfs#g' /etc/fdfs/client.conf
fi

if [ ! -z $tracker_server_port ] ; then
	sed -i 's/^http.tracker_server_port=.*/http.tracker_server_port='$tracker_server_port'/g' /etc/fdfs/client.conf
fi
#exec php-fpm

# first arg is `-f` or `--some-option`
# or first arg is `something.conf`
#if [ "${1#-}" != "$1" ] || [ "${1%.conf}" != "$1" ]; then
#	set -- php-fpm "$@"
#fi

php-fpm