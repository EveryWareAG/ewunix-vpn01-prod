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

# EOF
