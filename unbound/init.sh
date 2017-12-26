#!/bin/bash
[[ -n $DEBUG ]] && set -x

domainstxt="/etc/unbound/domains.txt"
unboundconf="/etc/unbound/unbound.conf"
adblockdb="/etc/unbound/adblock.db"

errout(){ echo -e "\e[31m$1\e[m" >&2 }

builddb(){
    local redirect=$1
    local record
    echo -n "Building database..."
    while read domain; do
        [[ $domain =~ ^# ]] && continue
        if [[ -n $redirect ]]; then
            record="local-zone: \"$domain\" redirect\n"
            record+="local-data: \"$domain A $DUMMY_HTTP_SERVER_V4\"\n"
            record+="local-data: \"$domain AAAA $DUMMY_HTTP_SERVER_V6\"\n"
        else
            record="local-zone: \"$domain\" static\n"
        fi
        echo -ne "$record" >> $adblockdb
    done < $domainstxt
    echo "done"
}

if [[ -z $DUMMY_HTTP_SERVER_V4 ]] && [[ -z $DUMMY_HTTP_SERVER_V6 ]]; then
    builddb
elif [[ -n $DUMMY_HTTP_SERVER_V4 ]] && [[ -n $DUMMY_HTTP_SERVER_V6 ]]; then
    builddb "redirect"
else
    errout "Please set/unset both DUMMY_HTTP_SERVER_V4 and DUMMY_HTTP_SERVER_V6."
    exit 1
fi

if [[ -z "$PRIMARY_FORWARDER" ]] || [[ -z "$SECONDARY_FORWARDER" ]]; then
    errout "Please set PRIMARY_FORWARDER and SECONDARY_FORWARDER."
    exit 2
fi

sed -i "s/{{PRIMARY_FORWARDER}}/$PRIMARY_FORWARDER/" $unboundconf
sed -i "s/{{SECONDARY_FORWARDER}}/$SECONDARY_FORWARDER/" $unboundconf

cat $unboundconf
/sbin/unbound-checkconf $unboundconf \
&& exec /sbin/unbound -c $unboundconf -d -v
