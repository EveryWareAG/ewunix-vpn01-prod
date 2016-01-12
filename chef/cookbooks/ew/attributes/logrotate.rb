# Logrotate attributes

### Logrotate
default['logrotate']['global']['compress'] = true
default['logrotate']['global']['weekly'] = true
default['logrotate']['global']['su'] = 'root syslog'
default['logrotate']['global']['rotate'] = 4
default['logrotate']['global']['create'] = ''
# wtmp und btmp Einträge werden vom logrotate Cookbook erzeugt. Wollen "wir" nicht.
default['logrotate']['global'].delete('/var/log/wtmp')
default['logrotate']['global'].delete('/var/log/btmp')

# EOF
