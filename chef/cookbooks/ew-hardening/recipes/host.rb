#
# Cookbook Name:: ew-hardening
# Recipe:: host
#
# Copyright 2015, EveryWare
#
# All rights reserved - Do Not Redistribute
#

# Hardening des Systems - für "Host"; NICHT für LXC Container!

#############################################
# CIS: /run/shm mount Optionen
mount "CIS: /run/shm Mount-Optionen anpassen" do
    device "none"
    mount_point "/run/shm"
    device_type "tmpfs"
    options "rw,nosuid,nodev,relatime,noexec"
    dump 0
    pass 0
    supports {:remount => true}
    action [:disable, :enable, :mount]
end # of mount "CIS: /run/shm Mount-Optionen anpassen" do

#############################################
# Kernel Modul Support entfernen
%w[everyware-cis-uncommon-network-protocols-support-remove everyware-cis-filesystem-support-remove].each do |modprobefile|
    cookbook_file "CIS: Kernel Modul-Support entfernen - /etc/modprobe.d/" + modprobefile + ".conf" do
        source "modprobe.d/" + modprobefile + ".conf"
        path "/etc/modprobe.d/" + modprobefile + ".conf"
        mode "0644"
        owner "root"
        group "root"
        action :create
    end # of cookbook_file "CIS: Kernel Modul-Support entfernen - /etc/modprobe.d/" + modprobefile + ".conf" do
end # of %w[everyware-cis-uncommon-network-protocols-support-remove everyware-cis-filesystem-support-remove].each do |modprobefile|

#############################################
# Kernel-Parameter/sysctl laden
%w[99-ew-network-parameters-host].each do |sysctlfile|
    cookbook_file "Kernel-Parameter Datei für Host anlegen: /etc/sysctl.d/" + sysctlfile + ".conf" do
        source "sysctl.d/" + sysctlfile + ".conf"
        path "/etc/sysctl.d/" + sysctlfile + ".conf"
        mode "0644"
        owner "root"
        group "root"
        action :create
    end # of cookbook_file "IPv6 deaktivieren" do

    bash "Kernel-Parameter Datei für Host einlesen: /etc/sysctl.d/" + sysctlfile + ".conf" do
        user "root"
        code <<-EOread_sysctl_file
            sysctl -p "/etc/sysctl.d/#{sysctlfile}.conf"
            sysctl -q -w net.ipv4.route.flush=1
        EOread_sysctl_file
    end # of bash "Kernel-Parameter Datei einlesen: /etc/sysctl.d/" + sysctlfile + ".conf" do
end # of %w[99-ew-ipv6-disable 99-ew-network-parameters].each do |sysctlfile|

# EOF
