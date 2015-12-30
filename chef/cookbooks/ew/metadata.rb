name              'ew'
maintainer        'EveryWare'
maintainer_email  'alexander.skwar@everyware.ch'
license           'Apache 2.0'
description       'Basic installations and configurations on snbng nodes'
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           '1.1.0'
recipe            'default', 'Basic configuration for all nodes'
supports          'ubuntu'
#depends           'openssh', '~> 1.5.2'
depends           'openssh'
depends           'resolver'
depends           'apt'
depends           'logrotate'
