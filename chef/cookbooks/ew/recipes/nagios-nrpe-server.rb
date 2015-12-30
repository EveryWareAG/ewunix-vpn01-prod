#
# Cookbook Name:: ew
# Recipe:: nagios-nrpe-server
#
# Copyright 2015, EveryWare
#
# All rights reserved - Do Not Redistribute
#

# Nagios NRPE Server auf dem Client konfigurieren
#############################################

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

service "nagios-nrpe-server" do
    supports :status => true, :restart => true, :reload => true
    action [ :enable, :start ]
end # of service "rsyslog" do

# EOF
