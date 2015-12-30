# Parameter für sshd_config - wird von openssh Cookbook verwendet.
default['openssh']['server']['permit_root_login'] = 'no'
default['openssh']['server']['max_auth_tries'] = '4'

# EOF