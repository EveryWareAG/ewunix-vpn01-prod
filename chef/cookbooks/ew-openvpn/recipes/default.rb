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

# "rake" Paket wird benötigt
package 'rake' do
    action :install
end # of package 'rake' do

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

# OpenVPN tls-auth Key erzeugen
bash 'tls-auth-key' do
  code <<-EOF
    openvpn --genkey --secret #{node['openvpn']['tls_key']}
  EOF

  not_if {node['openvpn']['tls_key'].nil?}
  not_if { ::File.exists?(node['openvpn']['tls_key']) }
end # of bash 'tls-auth-key' do

# server.conf erzeugen. Hier, da "dhcp_dns" zu übergeben ist. Wird
# beim Default nicht gemacht.
openvpn_conf 'server' do
  port node['openvpn']['port']
  proto node['openvpn']['proto']
  type node['openvpn']['type']
  local node['openvpn']['local']
  routes node['openvpn']['routes']
  script_security node['openvpn']['script_security']
  key_dir node['openvpn']['key_dir']
  key_size node['openvpn']['key']['size']
  subnet node['openvpn']['subnet']
  netmask node['openvpn']['netmask']
  user node['openvpn']['user']
  group node['openvpn']['group']
  log node['openvpn']['log']
  dhcp_dns node['openvpn']['dhcp_dns']
  tls_key node['openvpn']['tls_key']
  verb node['openvpn']['verb']

  not_if { node['openvpn']['configure_default_server'] }
  notifies :restart, 'service[openvpn]'
end

# Hilfsscript, um User revoken zu können
cookbook_file '/etc/openvpn/easy-rsa/revoke.sh' do
    source 'openvpn/easy-rsa/revoke.sh'

    owner 'root'
    group 'root'
    mode '0755'
end # of cookbook_file '/etc/openvpn/easy-rsa/revoke.sh' do

# Hilfsscript, um User revoken zu können - easy-rsa/revoke-full
cookbook_file '/etc/openvpn/easy-rsa/revoke-full' do
    source 'openvpn/easy-rsa/revoke-full'

    owner 'root'
    group 'root'
    mode '0755'
end # of cookbook_file '/etc/openvpn/easy-rsa/revoke-full' do

# Verzeichnisberechtigungen "offener" machen, sonst klappt bestimmtes,
# wie z.B. crl-verify, nicht.
key_dir  = node['openvpn']['key_dir']

directory key_dir do
  mode  '0755'
end

# Leere crl.pem anlegen
file 'Leere CRL Datei anlegen: ' + key_dir + '/crl.pem' do
    path key_dir + '/crl.pem'

    content "# Wird bei revoke-full angelegt\n"
    action :create_if_missing
end # of file 'Leere CRL Datei anlegen: ' + key_dir + '/crl.pem' do

# Berechtigungen anpassen
file 'CRL Datei Berechtigungen anpassen: ' + key_dir + '/crl.pem' do
    path key_dir + '/crl.pem'

    owner 'root'
    group 'root'
    mode '0644'
end # of file 'CRL Datei Berechtigungen anpassen: ' + key_dir + '/crl.pem' do
file 'server.key Berechtigungen anpassen: /etc/openvpn/keys/server.key' do
    path '/etc/openvpn/keys/server.key'

    mode '0600'
end # of file 'server.key Berechtigungen anpassen: /etc/openvpn/keys/server.key' do

# EOF
