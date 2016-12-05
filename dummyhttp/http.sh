#!/bin/ash
while true; do
    echo -ne "HTTP/1.1 204 No Content\n\n" | nc -l -p 80
done
