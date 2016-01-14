# openvpn-server

Cookbook(s) um ein System hiermit als OpenVPN Server zu konfigurieren.

# Benutzer

Um den OpenVPN Server nutzen zu können/dürfen, müssen Nutzer ein vom Server signiertes Zertifikat in ihrem OpenVPN Client hinterlegt haben und es passend konfiguriert haben. Zur einfacheren Handhabung kann dafür `easy-rsa` genutzt werden.

## Anlegen

Um eine `$USER.ovpn` Konfigurationsdatei mit allem benötigten anzulegen, mache man (als `root`):

 1. Die `easy-rsa` Variablen aus `/etc/openvpn/easy-rsa/vars` laden: `cd /etc/openvpn/easy-rsa; source vars`
 2. Mit dem Rakefile `Rakefile-ovpn` die Datei für den User erstellen: `rake -f Rakefile-ovpn client gateway=$(hostname -f) name=test-ask-tablet-3`

Dies lässt sich auch per `sudo` aufrufen:

```bash
█▓▒░local@ewunix-vpn01-prod░▒▓██▓▒░ Mit Jan 13 03:38:54 
~/ sudo bash -c "cd /etc/openvpn/easy-rsa; source vars; rake -f Rakefile-ovpn client gateway=$(hostname -f) name='Rüdi Meier'"                      
NOTE: If you run ./clean-all, I will be doing a rm -rf on /etc/openvpn/keys
* Generate certificate for Rüdi Meier.
./pkitool 'Rüdi Meier'
Generating a 2048 bit RSA private key
................+++
................+++
writing new private key to 'Rüdi Meier.key'
-----
Using configuration from /etc/openvpn/easy-rsa/openssl.cnf
Check that the request matches the signature
Signature ok
The Subject's Distinguished Name is as follows
countryName           :PRINTABLE:'CH'
stateOrProvinceName   :PRINTABLE:'ZRH'
localityName          :PRINTABLE:'Zurich'
organizationName      :PRINTABLE:'EveryWare AG'
organizationalUnitName:PRINTABLE:'OpenVPN Server'
commonName            :T61STRING:'R\0xFFFFFFC3\0xFFFFFFBCdi Meier'
emailAddress          :IA5STRING:'unix@everyware.ch'
Certificate is to be certified until Jan 10 14:58:58 2026 GMT (3650 days)

Write out database with 1 new entries
Data Base Updated
* Generate configuration files for Rüdi Meier
* Done, Rüdi Meier configuration is in /etc/openvpn/keys/../user-conf/Rüdi Meier@ewunix-vpn01-prod.intern.ewcs.ch.ovpn
```

Zur noch einfacheren Nutzung gibt es das Script **`/etc/openvpn/easy-rsa/generate.sh`**.

## Löschen / Revoke

Benutzer können so lange den OpenVPN Dienst nutzen, wie sie ein gültiges Zertifikat vorweisen. Um ein Zertifikat *"richtig"* zurückzuziehen (ein Revoke zu machen), verwende man das `revoke-full` Script von `easy-rsa`:

```bash
█▓▒░local@ewunix-vpn01-prod░▒▓██▓▒░ Mit Jan 13 04:11:47 
~/ sudo bash -c 'cd /etc/openvpn/easy-rsa; source ./vars; ./revoke-full "Rüdi Meier"'    
NOTE: If you run ./clean-all, I will be doing a rm -rf on /etc/openvpn/keys
Using configuration from /etc/openvpn/easy-rsa/openssl.cnf
Revoking Certificate 08.
Data Base Updated
Using configuration from /etc/openvpn/easy-rsa/openssl.cnf
Rüdi Meier.crt: C = CH, ST = ZRH, L = Zurich, O = EveryWare AG, OU = OpenVPN Server, CN = R\C3\83\C2\BCdi Meier, emailAddress = unix@everyware.ch
error 23 at 0 depth lookup:certificate revoked
```

Der **error 23** ist ***richtig*** und erwartet; er zeigt an, dass das Zeritifkat nicht (mehr) verifiziert werden kann.
