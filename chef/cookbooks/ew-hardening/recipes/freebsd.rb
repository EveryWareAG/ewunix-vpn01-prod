#
# Cookbook Name:: freebsd-lockdown-snb
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

template '/etc/syslog.conf' do
  source 'syslog.conf.erb'
  mode '0644'
  owner 'root'
  group 'wheel'
  action :create
  variables(
    :syslogserver => node['ew'][:syslogserver]
  )
end

cookbook_file '/etc/newsyslog.conf' do
  source 'newsyslog.conf'
  mode '644'
  owner 'root'
  group 'wheel'
end


service 'syslogd' do
  action [:enable, :start]
end