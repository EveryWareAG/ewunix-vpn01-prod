#
# Cookbook Name:: postfix
# Recipe:: default
#
# Copyright 2014, EveryWare AG
#
# All rights reserved - Do Not Redistribute
#

apt_package "postfix" do
  response_file 'postfix.preseed'
  supports :restart => true, :reload => true
  action :install
end

apt_package "mailutils" do
  action :install
end

service 'postfix' do
  action [ :enable, :start ]
end

bash "postconf_interfaces_localhost" do
  user "root"
  code <<-EOS
  postconf -e inet_interfaces=localhost
  EOS
  not_if "egrep -q '^inet_interfaces.*localhost' /etc/postfix/main.cf"
  notifies :restart, 'service[postfix]'
end

bash "root_alias" do
  user "root"
  code <<-EOS
  printf "root:\t%s@systems.everyware.ch\n" "linux" >> /etc/aliases
  newaliases
  EOS
  not_if "egrep -q 'linux.*systems.everyware.ch' /etc/aliases"
  notifies :reload, 'service[postfix]'
end
