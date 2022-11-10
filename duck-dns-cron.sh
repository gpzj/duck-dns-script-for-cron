#!/bin/bash

# Verify args.
## site to update.
if [ $1 ];
then
    site=$1
else
    echo "error site not defined."
    exit 0
fi

## token
if [ $2 ];
then
    token=$2
else
    echo "error token not defined."
    exit 0
fi

# cron monitoring
if [ $3 ];
then
    if ! [ $4 ];
    then
        echo "error alertapitoken not passed."
    else
        alert_api_ip=$3
        alert_api_token=$4
    fi
fi

# Get Current IPv4 Address.
# Turns out duckdns api does this automatically, but leaving this so i remember for if/when I start using aws for the domain instead.
# ipv4_regex='^((25[0-5]|(2[0-4]|1\d|[1-9]|)\d)\.?\b){4}$'
# ipv4=$(curl -s 'https://api.ipify.org?format=json' | jq -r '.ip')
duckdns_api_base_url='https://www.duckdns.org/update?domains='
duckdns_full_api="$duckdns_api_base_url$site&token=$token"

# Verify IP returned OK
# if ! [[ $ipv4 =~ $ipv4_regex ]];
# then
#     echo 'valid ipv4 not returned'
#     exit 0
# fi

# Update IP to DuckDNS.
update=$(curl -s $duckdns_full_api)

# If defined, send status to uptime kuma or other cron monitoring api.
if [ $alert_api_ip ] && [ $update = 'OK' ];
then
    curl -s "http://$alert_api_ip/api/push/$alert_api_token?status=up&msg=OK&ping=" > /dev/null
fi

# testing to delete.
# echo "$duckdns_full_api"
# echo "IPV4: $ipv4"
# echo "site: $site"
# echo "token: $token"
# echo "alertapi: $alertapi"
# echo "alertapitoken: $alertapitoken"

