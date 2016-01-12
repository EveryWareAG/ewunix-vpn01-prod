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

directory "/usr/lib/nagios/eventhandler/" do
    owner "nagios"
    group "nagios"
    mode "0644"
    action :create
end

cookbook_file "/usr/lib/nagios/plugins/check_glusterfs" do
    source "nagios/plugin-scripts/check_glusterfs"
    owner "root"
    group "root"
    mode "0755"
end

cookbook_file "/usr/lib/nagios/plugins/check_dumpmysql" do
    source "nagios/plugin-scripts/check_dumpmysql"
    owner "root"
    group "root"
    mode "0755"
end

cookbook_file "/etc/sudoers.d/nagios" do
    source "sudoers.d/nagios"
    owner "root"
    group "root"
    mode "0440"
end

# Verzeichnisse
directory "Nagios Config Directory: /etc/nagios" do
    path "/etc/nagios"
    owner "root"
    group "root"
    mode "0755"
end # of directory "Nagios Config Directory: /etc/nagios" do
directory "Nagios Include Config Directory: /etc/nagios/nrpe.d" do
    path "/etc/nagios/nrpe.d"
    owner "root"
    group "root"
    mode "0755"
end # of directory "Nagios Include Config Directory: /etc/nagios/nrpe.d" do
directory "Nagios Pid Directory: /var/run/nagios" do
    path "/var/run/nagios"
    owner "nagios"
    group "root"
    mode "0755"
end # of directory "Nagios Pid Directory: /var/run/nagios" do

# Konfigurationsdateien
cookbook_file "Nagios Haupt Config: /etc/nagios/nrpe.cfg" do
    source "nagios/nrpe.cfg"
    path "/etc/nagios/nrpe.cfg"
    owner "root"
    group "root"
    mode "0644"
    notifies :restart, 'service[nagios-nrpe-server]', :delayed
end # of cookbook_file "Nagios Haupt Config: /etc/nagios/nrpe.cfg" do
cookbook_file "Nagios Linux Config: /etc/nagios/nrpe.d/linux.cfg" do
    source "nagios/nrpe.d/linux.cfg"
    path "/etc/nagios/nrpe.d/linux.cfg"
    owner "root"
    group "root"
    mode "0644"
    notifies :restart, 'service[nagios-nrpe-server]', :delayed
end # of cookbook_file "Nagios Linux Config: /etc/nagios/nrpe.d/linux.cfg"
