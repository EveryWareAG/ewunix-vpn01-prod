name                'vpn-server'
maintainer          'EveryWare AG'
maintainer_email    'alexander.skwar@everyware.ch'
license             'All rights reserved'
description         'Installs/Configures OpenVPN Server'
long_description    IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version             '0.2.5'
#depends             'apt', '~> 2.2'
depends             'openvpn', '~> 2.1.0'