#
# Cookbook Name:: ew-bash_audit
# Recipe:: default
#
# Copyright 2015, EveryWare
#
# All rights reserved - Do Not Redistribute
#

# Konfiguriere bash_audit auf dem System
#
# NACH dem syslog Cookbook aufrufen, da dort das rsyslog.d Verzeichnis gelöscht wird!
#
# Siehe http://wiki.1st.ch/doku.php?id=everyware:intern:bash_logging
# und https://ewserv-git01-prod.everyware.internal/unix/scripts/tree/master/shell-audit

file "Alte bash_audit DATEI entfernen" do
    path "/etc/bash_audit"
    action :delete
    only_if { ::File.file?("/etc/bash_audit") }
end # of file "Alte bash_audit DATEI entfernen" do

directory "bash audit VERZEICHNIS anlegen: /etc/bash_audit" do 
    path '/etc/bash_audit'
    owner 'root'
end # of directory "bash audit Verzeichnis: /etc/bash_audit" do 

cookbook_file "bash audit Hauptdatei anlegen: /etc/bash_audit/bash_audit" do
    path "/etc/bash_audit/bash_audit"
    source "bash_audit"
    mode "0644"
    owner "root"
    group "root"
    action :create
end # of cookbook_file "bash audit Hauptdatei: /etc/bash_audit" do

cookbook_file "bash audit rsyslog Datei anlegen: /etc/rsyslog.d/45-bash-audit.conf" do
    path "/etc/rsyslog.d/45-bash-audit.conf"
    source "45-bash-audit.conf"
    mode "0644"
    owner "root"
    group "root"
    action :create
    notifies :reload, 'service[rsyslog]', :delayed
end # of cookbook_file "bash audit rsyslog Datei anlegen: /etc/rsyslog.d/45-bash-audit.conf" do

cookbook_file "bash audit SSH Force Command Datei: /etc/bash_audit/forcecommand.sh" do
    path "/etc/bash_audit/forcecommand.sh"
    source "forcecommand.sh"
    mode "0755"
    owner "root"
    group "root"
    action :create
    notifies :reload, "service[ssh]", :delayed
end # of cookbook_file "bash audit SSH Force Command Datei: /etc/bash_audit/forcecommand.sh" do

ruby_block "Lade bash_audit" do
    block do
        fe = Chef::Util::FileEdit.new("/etc/bash.bashrc")
        # Alle "bash_audit" Zeilen entfernen
        fe.search_file_delete_line(/bash_audit/)
        # Datei schreiben, bevor in der Datei gesucht wird.
        fe.write_file
        # Neue Zeile hinzu
        fe.insert_line_if_no_match(/bash_audit/,
                                   "[ -f /etc/bash_audit/bash_audit ] && . /etc/bash_audit/bash_audit")
        # Datei schreiben, mit allen Änderungen.
        fe.write_file
    end # of block do
end # of ruby_block "Lade bash_audit" do

%w[ /root /home/local ].each do |dirname|
    file dirname + "/.bashrc" do
        action :create_if_missing
        user "root"
        mode "0664"
        content ""
    end # of file dirname + "/.bashrc" do
end # of %w[ /root /home/local ].each do |dirname|

#############################################
# Services

# Define the rsyslog service
service "rsyslog" do
    provider Chef::Provider::Service::Upstart
    supports :status => true, :restart => true, :reload => true
    action [ :enable, :start ]
end # of service "rsyslog" do

# Define the sshd service
service "ssh" do
    provider Chef::Provider::Service::Upstart
    supports :status => true, :restart => true, :reload => true
    action [ :enable, :restart ]
end # of service "ssh" do

# EOF
