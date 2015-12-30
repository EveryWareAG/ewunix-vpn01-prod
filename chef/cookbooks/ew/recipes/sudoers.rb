#
# Cookbook Name:: ew
# Recipe:: sudoers
#
# Copyright 2015, EveryWare
#
# All rights reserved - Do Not Redistribute
#
#
# Lege sudoers.d/nopw Datei an
#
#############################################

cookbook_file "sudoers.d/nopw Datei anlegen" do
    source "sudoers-nopw"
    path "/etc/sudoers.d/nopw"
    mode "0600"
    owner "root"
    group "root"
end # of cookbook_file "sudoers.d/nopw Datei anlegen" do

# EOF

