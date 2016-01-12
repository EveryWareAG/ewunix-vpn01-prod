#
# Cookbook Name:: ew
# Recipe:: default
#
# Copyright 2015, EveryWare
#
# All rights reserved - Do Not Redistribute
#

# Recipe, welches ein System als EveryWare System konfiguriert

# "openssh" Cookbook "ausführen" - erzeugt /etc/ssh/sshd_config
include_recipe "openssh"

# "resolver" Cookbook "ausführen" - erzeugt /etc/resolv.conf
include_recipe 'resolver'

# "ew::repos" Cookbook "ausführen" - passt Ubuntu Repositories in /etc/apt an.
include_recipe 'resolver'

#############################################
# Wichtige grundlegende Basics!

# Disable chef-client (we run chef-zero in this kitchen)
service "Disable chef-client Service" do
    service_name "chef-client"
    pattern 'ruby /usr/bin/chef-client'
    action [ :stop, :disable ]
    supports :status => true, :restart => true, :reload => true
end # of service "Disable chef-client Service" do

#############################################
# Locale
remote_directory "/var/lib/locales/supported.d" do
    files_mode "0644"
    files_owner "root"
    mode "0755"
    owner "root"
    source "locale"
end
bash "locale-gen" do
    user "root"
    code <<-EOlocale_gen
        locale-gen
    EOlocale_gen
end

#############################################
# useradd soll keine Gruppen erzeugen
bash "login.defs - useradd no groups" do
    user "root"
    code <<-EOlogin_defs_USERGROUPS_ENAB
        sed -i 's,USERGROUPS_ENAB yes,USERGROUPS_ENAB no,' /etc/login.defs
    EOlogin_defs_USERGROUPS_ENAB
end

#############################################
# VIM customization
cookbook_file "/etc/vim/vimrc.local" do
    source "vimrc.local"
    mode "0644"
    owner "root"
    group "root"
end

#############################################
# Extra Pakete installieren
package node[:ew][:extra_packages] do
    action :install
end # of package node[:ew][:extra_packages]

#############################################
# User
# "Standard" User Account "local" anlegen
user "local" do
    username "local"
    comment "Unnamed local default user"
    manage_home true
    action :create
end # of user "local" do

# Shell von "Standardusern" auf zsh ändern
%w[local root].each do |username|
    user "Set login shell to zsh for user " + username do
        username username
        shell "/bin/zsh"
        action :modify
    end # of user "Set login shell to zsh for user " + username do
end # of %w[local root].each do |username|

#############################################
# NTP
remote_directory "ntp default Dateien für /etc/default" do
    path "/etc/default"
    source "ntp/default"

    files_mode "0644"
    files_owner "root"

    mode "0755"
    owner "root"
    group "root"

    purge false
end # of remote_directory "ntp default Dateien für /etc/default" do

template "/etc/ntp.conf" do
    source "ntp/ntp.conf.erb"
    variables({
        :ntp_server =>  node['ew'][:ntpserver]
    })
    mode "0644"
    owner "root"
    group "root"
end # of template "/etc/ntp.conf" do

service "ntp" do
    supports :status => true, :restart => true, :reload => true
    action [ :enable, :start ]
end # of service "rsyslog" do

# EOF
