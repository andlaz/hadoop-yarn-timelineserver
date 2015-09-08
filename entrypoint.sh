#!/usr/bin/env bash

# Allow parameters to configure.rb to come from CONFIGURE_PARAMS as opposed to stdin
# This is to support parameterizing via Compose in particular. The two lines below are equivalent in effect:
# docker run -e "CONFIGURE_PARAMS=cassandra --dc daas-1 --calculate-tokens 1:1" -ti --name c1 --rm andlaz/hadoop-cassandra
# docker run -ti --name c1 --rm andlaz/hadoop-cassandra cassandra --dc daas-1 --calculate-tokens 1:1
P=${CONFIGURE_PARAMS:-$(echo $*)}
set -- $P

add_timelineserver_options () {
	
	local opts=""
	
	if [ $HOSTNAME ] && [ ! "$*" == *"--hostname"* ]; then opts="$opts --hostname $HOSTNAME"; fi
	
	echo $opts
}


case $1 in
	help) ruby /root/configure.rb $* ;;
	timelineserver) ruby /root/configure.rb $* `add_timelineserver_options $*` && supervisord -c /etc/supervisord.conf ;;
	*) ruby /root/configure.rb $* && supervisord -c /etc/supervisord.conf
esac

