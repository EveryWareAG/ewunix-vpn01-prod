#!/bin/sh

. /etc/openvpn/easy-rsa/vars

if [ -z "$1" ]; then
    echo "Aufruf: $0 <user-der-revoked-werden-soll>"
    echo ""
    echo "Beispiel:"
    echo "$0 \"John Doe\""
    echo ""
    echo "Hierfür muss eine entsprechende Zertifikatsdatei .crt"
    echo "im Ordner /etc/openvpn/keys geben."
    echo ""
    exit 1
fi

KEY_CN="$1"
CRT="/etc/openvpn/keys/$KEY_CN.crt"

if [ ! -r "$CRT" ]; then
    echo "Fehler! Keine Zertifikatsdatei für $KEY_CN gefunden."
    echo "Gesucht nach: $CRT"
    exit 1
fi

openssl ca -config "$KEY_CONFIG" -revoke "$CRT"

exit $?

# EOF
