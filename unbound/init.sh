#!/bin/bash

config="/etc/unbound/unbound.conf"
db="/etc/unbound/ad.db"

NUM_THREADS="${NUM_THREADS:-1}"
USE_CAPS_FOR_ID="${USE_CAPS_FOR_ID:-no}"
LOG_ENABLE="${LOG_ENABLE:-no}"
LOG_QUERIES="${LOG_QUERIES:-no}"
VERBOSITY="${VERBOSITY:-1}"
PRIMARY_FORWARDER="${PRIMARY_FORWARDER}"
SECONDARY_FORWARDER="${SECONDARY_FORWARDER}"

DUMMY_HTTP_SERVER_V4="${DUMMY_HTTP_SERVER_V4:-160.16.52.240}"
DUMMY_HTTP_SERVER_V6="${DUMMY_HTTP_SERVER_V6:-2001:e42:102:1502:160:16:52:240}"

sed -i "s/{{NUM_THREADS}}/${NUM_THREADS}/" $config
sed -i "s/{{USE_CAPS_FOR_ID}}/${USE_CAPS_FOR_ID}/" $config
sed -i "s/{{LOG_QUERIES}}/${LOG_QUERIES}/" $config
sed -i "s/{{VERBOSITY}}/${VERBOSITY}/" $config

if [[ "$LOG_ENABLE" = "yes" ]]; then
    sed -i "s/{{LOG_ENABLE}}/${LOG_ENABLE}/" $config
else
    sed -i "s/{{LOG_ENABLE}}/\"\"/" $config
fi

if [[ -z "$PRIMARY_FORWARDER" ]] && [[ -z "$SECONDARY_FORWARDER" ]]; then
    sed -i "/forward-zone:/d" $config
    sed -i "/name: \".\"/d" $config
    sed -i "/forward-addr:/d" $config
else
    sed -i "s/{{PRIMARY_FORWARDER}}/${PRIMARY_FORWARDER}/" $config
    sed -i "s/{{SECONDARY_FORWARDER}}/${SECONDARY_FORWARDER}/" $config
fi
sed -i "s/{{DUMMY_HTTP_SERVER_V4}}/${DUMMY_HTTP_SERVER_V4}/g" $db
sed -i "s/{{DUMMY_HTTP_SERVER_V6}}/${DUMMY_HTTP_SERVER_V6}/g" $db

cat $config
/sbin/unbound-checkconf $config && exec /sbin/unbound -c $config -d -v
