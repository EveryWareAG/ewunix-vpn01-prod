#
# Cookbook Name:: vpn-server
# Recipe:: default
#
# Copyright 2016, EveryWare AG
#
# All rights reserved - Do Not Redistribute
#

# Wrapper Cookbook für das "openvpn" Cookbook

# Rufe das openvpn::default Recipe auf
include_recipe 'openvpn'

# server.up.d Script für iptables anlegen
template "server.up.d/iptables-nat Script" do
    source 'openvpn/server.up.d/iptables-nat.sh'
    path '/etc/openvpn/server.up.d/iptables-nat.sh'

    owner 'root'
    group 'root'
    mode '0644'
    
    notifies :restart, 'service[openvpn]'
end # of template "server.up.d/iptables-nat Script" do

# Rakefile für die Erzeugung von .ovpn Dateien erstellen
template "/etc/openvpn/easy-rsa/Rakefile-ovpn" do
    source "openvpn/Rakefile-ovpn.erb"

    owner 'root'
    group 'root'
    mode  '0755'
end

# Verzeichnis für User Conf
directory default['openvpn']['key_dir'] + '/../user-conf' do
    owner 'root'
    group 'root'
    mode '0755'
end # of directory default['openvpn']['key_dir'] + '/../user-conf' do

# "rake" Paket wird benötigt
package 'rake' do
    action :install
end # of package 'rake' do
# EOF
