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

# EOF
