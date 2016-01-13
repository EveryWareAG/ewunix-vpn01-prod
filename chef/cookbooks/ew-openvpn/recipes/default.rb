#
# Cookbook Name:: vpn-server
# Recipe:: default
#
# Copyright 2016, EveryWare AG
#
# All rights reserved - Do Not Redistribute
#

# Wrapper Cookbook für das "openvpn" Cookbook

# Verzeichnisse erzeugen - rekursiv.
[node['openvpn']['key_dir'], node['openvpn']['key_dir'] + '/../user-conf'].each do |dir|
    directory dir do
        owner 'root'
        group 'root'
        mode '0755'

        recursive true
    end # of directory dir do
end # of [node['openvpn']['key_dir'], node['openvpn']['key_dir'] + '/../user-conf'].each do |dir|

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

cookbook_file '/etc/openvpn/update-resolv-conf' do
    source 'openvpn/update-resolv-conf'

    owner 'root'
    group 'root'
    mode '0755'
end # of cookbook_file '/etc/openvpn/update-resolv-conf' do

# "rake" Paket wird benötigt
package 'rake' do
    action :install
end # of package 'rake' do

# EOF
