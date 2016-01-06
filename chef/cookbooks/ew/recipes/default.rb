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
# Wir brauchen "make" und "zsh"
%w[make zsh].each do |pkg|
    package "EveryWare Extra Paket installieren: " + pkg do
        package_name pkg
        action :install
    end # of package "EveryWare Extra Paket installieren: " + pkg do
end # end of %w[make zsh].each do |pkg|

#############################################
# Shell von "Standardusern" auf zsh ändern
%w[local root].each do |username|
    bash "Login Shell für User " + username + " auf zsh ändern" do
        user "root"
        code <<-EOchsh
            chsh -s /bin/zsh #{username}
        EOchsh
        not_if "getent passwd " + username + " | grep 'zsh$'"
    end # of bash "Login Shell für User " + username + " auf zsh ändern" do
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
