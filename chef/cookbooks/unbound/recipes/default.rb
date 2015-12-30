#
# Cookbook Name:: unbound
# Recipe:: default
#
# Copyright 2014, EveryWare AG
#
# All rights reserved - Do Not Redistribute
#

service "unbound" do
  supports :restart => true, :reload => true
  action :enable
end

template "/etc/unbound/unbound.conf.d/forward-zone.conf" do
  source "forward-zone.conf.erb"
  mode "0644"
  action :create
  notifies :reload, 'service[unbound]'
end
