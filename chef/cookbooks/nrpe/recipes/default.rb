#
# Cookbook Name:: nrpe
# Recipe:: default
#
# Copyright 2014, EveryWare AG
#
# All rights reserved - Do Not Redistribute
#

apt_package "nagios-nrpe-server" do
  action :install
end

service "nagios-nrpe-server" do
  supports :restart => true, :reload => true
  action :enable
end

apt_package "xinetd" do
  action :install
end

service "xinetd" do
  provider Chef::Provider::Service::Upstart
  supports :restart => true, :reload => true
  action :enable
end

template "/etc/nagios/nrpe_local.cfg" do
  source "nrpe_local.cfg.erb"
  mode "0644"
  action :create
  notifies :restart, "service[nagios-nrpe-server]", :delayed
end

template "/etc/nagios/nrpe.d/linux.cfg" do
  source "linux.cfg.erb"
  mode "0644"
  action :create
  notifies :restart, "service[nagios-nrpe-server]", :delayed
end

directory "/usr/lib/nagios/eventhandler/" do
  owner "nagios"
  group "nagios"
  mode 0644
  action :create
end

cookbook_file "/usr/lib/nagios/plugins/check_glusterfs" do
  source "check_glusterfs"
  mode "0755"
end

cookbook_file "/usr/lib/nagios/plugins/check_dumpmysql" do
  source "check_dumpmysql"
  mode "0755"
end

cookbook_file "/etc/sudoers.d/nagios" do
  owner "root"
  group "root"
  mode 0440
  source "sudo.nagios"
end
