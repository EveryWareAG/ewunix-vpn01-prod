#!/bin/sh

name="$1"

if [ -z "$name" ]; then
    echo "Fehler! Kein name angegeben!"
    echo "Aufruf: $0 \"Name des Benutzers\""
    exit 1
fi

cd /etc/openvpn/easy-rsa
. ./vars
rake -f Rakefile-ovpn client gateway=$(hostname -f) name="$name"

exit $?

# EOF