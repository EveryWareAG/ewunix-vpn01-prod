default['ew']['aptweek'] = ""

### OpenSSH
# Parameter für sshd_config - wird von openssh Cookbook verwendet.
default['openssh']['server']['port'] = '22'
default['openssh']['server']['log_level'] = 'INFO'
default['openssh']['server']['ignore_rhosts'] = 'yes'
default['openssh']['server']['permit_root_login'] = 'without-password'
default['openssh']['server']['banner'] = '/etc/issue.net'
default['openssh']['server']['use_privilege_separation'] = 'yes'
default['openssh']['server']['key_regeneration_interval'] = '3600'
default['openssh']['server']['server_key_bits'] = '1024'
default['openssh']['server']['syslog_facility'] = 'AUTH'
#default['openssh']['server']['login_grace_time'] = '120'   # Compass Security Audit SNB NG: 2015-09-15: 7.11.1, #4
default['openssh']['server']['login_grace_time'] = '30'
default['openssh']['server']['strict_modes'] = 'yes'
default['openssh']['server']['r_s_a_authentication'] = 'yes'
default['openssh']['server']['pubkey_authentication'] = 'yes'
default['openssh']['server']['rhosts_r_s_a_authentication'] = 'no'
default['openssh']['server']['challenge_response_authentication'] = 'no'
default['openssh']['server']['password_authentication'] = 'no'   # Compass Security Audit SNB NG: 2015-09-15: 7.11.1, #8
default['openssh']['server']['x11_forwarding'] = 'yes'
default['openssh']['server']['x11_display_offset'] = '10'
default['openssh']['server']['print_motd'] = 'no'
default['openssh']['server']['print_last_log'] = 'yes'
default['openssh']['server']['t_c_p_keep_alive'] = 'yes'
default['openssh']['server']['accept_env'] = 'LANG LC_*'
default['openssh']['server']['use_d_n_s'] = 'no'
default['openssh']['server']['subsystem'] = 'sftp internal-sftp'
default['openssh']['server']['kerberos_authentication'] = 'no'
default['openssh']['server']['pubkey_authentication'] = 'yes'
default['openssh']['server']['use_p_a_m'] = 'yes'
# default['openssh']['server']['host_key'] = [
#     '/etc/ssh/ssh_host_rsa_key',
#     '/etc/ssh/ssh_host_dsa_key',
#     '/etc/ssh/ssh_host_ecdsa_key',
#     '/etc/ssh/ssh_host_ed25519_key'
# ] # Compass Security Audit SNB NG: 2015-09-15: 7.11.1, #17
default['openssh']['server']['host_key'] = [
    '/etc/ssh/ssh_host_rsa_key',
    '/etc/ssh/ssh_host_ed25519_key'
] # Compass Security Audit SNB NG: 2015-09-15: 7.11.1, #17
default['openssh']['server']['ciphers'] = 'chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr'   # Compass Security Audit SNB NG: 2015-09-15: 7.11.1, #12
default['openssh']['server']['kex_algorithms'] = 'curve25519-sha256@libssh.org,diffie-hellman-group-exchange-sha256'   # Compass Security Audit SNB NG: 2015-09-15: 7.11.1, #13
default['openssh']['server']['m_a_cs'] = 'hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,hmac-ripemd160-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-512,hmac-sha2-256,hmac-ripemd160,umac-128@openssh.com'   # Compass Security Audit SNB NG: 2015-09-15: 7.11.1, #14
# X11 Forwarding klappt nicht: error: Failed to allocate internet-domain X11 display socket
# Lösung: AddressFamily inet
default['openssh']['server']['address_family'] = 'inet'

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
