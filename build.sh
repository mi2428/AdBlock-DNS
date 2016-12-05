#!/bin/bash
cd $(dirname $0)
set -eu

build(){
    [[ -f $out ]] && rm $out
    while read domain; do
        [[ $domain =~ ^# ]] && continue
        record="local-zone: \"$domain\" redirect\n"
        record+="local-data: \"$domain A {{DUMMY_HTTP_SERVER_V4}}\"\n"
        record+="local-data: \"$domain A {{DUMMY_HTTP_SERVER_V6}}\"\n"
        echo -ne "$record" >> $out
    done < $in
}

while getopts i:o: OPT; do
    case $OPT in
    i)
        declare -r in=$OPTARG ;;
    o)
        declare -r out=$OPTARG
        build ;;
    esac
done

