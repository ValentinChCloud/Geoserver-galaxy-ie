#!/bin/bash

sed -i "s|PROXY_PREFIX|${PROXY_PREFIX}|" /proxy.conf;
cp /proxy.conf /etc/nginx/sites-enabled/default;

# Here you would normally start whatever service you want to start. In our
# example we start a simple directory listing service on port 8000


#load dataset into openrefine

files=(/import/*)
until [[ -f "$files" ]]
do
	echo "Importing data from galaxy history "
	sleep 4
done


sh $GEOSERVER_HOME/startup.sh &




# Launch traffic monitor which will automatically kill the container if traffic
# stops
exec /monitor_traffic.sh &
#And nginx in foreground mode.
nginx -g 'daemon off;'
