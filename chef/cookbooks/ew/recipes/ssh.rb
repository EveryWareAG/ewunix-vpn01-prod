#
# Cookbook Name:: ew
# Recipe:: ssh
#
# Copyright 2015, EveryWare
#
# All rights reserved - Do Not Redistribute
#

# SSH Konfiguration - Server und Client

#############################################
# Install default .ssh directory
remote_directory "/root/.ssh" do
    files_mode '0600'
    files_owner 'root'
    files_group 'root'
    mode '0700'
    owner 'root'
    group 'root'
    source "default-ew-.ssh"
end

#############################################
# Deploy key for gitlab repository
remote_directory "/root/.ssh" do
    files_mode '0600'
    files_owner 'root'
    files_group 'root'
    mode '0700'
    owner 'root'
    group 'root'
    source "root-ssh"
end
file "/root/.ssh/id_rsa.pub" do
    mode '0644'
end

# EOF
