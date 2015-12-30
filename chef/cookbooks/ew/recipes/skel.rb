#
# Cookbook Name:: ew
# Recipe:: skel
#
# Copyright 2015, EveryWare
#
# All rights reserved - Do Not Redistribute
#

# Lege "Standard-Dateien" in /etc/skel an
# und auch bei /root und /home/local, sofern nicht existent
#############################################
# /etc/skel Dateien
%w[ zshrc shrc bashrc profile sh_aliases ].each do |skelfile|
    cookbook_file "skel Datei: " + skelfile do
        source "skel/" + skelfile
        path "/etc/skel/." + skelfile
        mode "0644"
        owner "root"
        group "root"
    end # of cookbook_file "skel Datei: " + skelfile do

    %w[root local].each do |username|
        cookbook_file "skel Datei für User " + username + " in homedir " + ::File.expand_path("~" + username) + ": " + skelfile do
            source "skel/" + skelfile
            path ::File.expand_path("~" + username + "/." + skelfile)
            mode "0644"
            owner ::File.stat(::File.expand_path("~" + username)).uid
            group ::File.stat(::File.expand_path("~" + username)).gid
            # owner username
            # group username
            not_if{ ::File.exist?(::File.expand_path("~" + username + "/." + skelfile)) }
        end # of cookbook_file "skel Datei in home" + homedir + ": " + skelfile do
    end # of %w[ /root /home/local ].each do |homedir|
end # of %w[ zshrc sh_aliases ].each do |skelfile|

# EOF
