#!/usr/bin/env bash

port=/dev/ttyACM0
baud_rate=9600

exec 3<> $port
stty -F $port $baud_rate

echo -n "$(($(date +%s%N)/1000000)) "

read_until_dot() {
    local response=""
    while true; do
        read -r -n 1 -u 3 char
        if [[ "$char" == "." ]]; then
            break
        fi
        response+="$char"
    done
    echo -n "$response" | tr -d '\r\n' | sed 's/^[ \t]*//;s/[ \t]*$//'
}

for side in "left" "right"; do
    echo -ne "wireless.battery.$side.level\n" >&3
    read_until_dot
    echo -n " "
done

for side in "left" "right"; do
    echo -ne "wireless.battery.$side.status\n" >&3
    read_until_dot
    echo -n " "
done

echo
exec 3>&-
