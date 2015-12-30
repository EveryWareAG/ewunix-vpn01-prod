#
# Cookbook Name:: ew-hardening
# Recipe:: default
#
# Copyright 2015, EveryWare
#
# All rights reserved - Do Not Redistribute
#

# Hardening des Systems

#############################################
# Shell Timeout setzen
tmout_h=10
tmout_s=tmout_h*60*60
bash "Shell Timeout TMOUT setzen auf " + tmout_h.to_s + "h = " + tmout_s.to_s + "s" do
    user "root"
    code <<-EOtmout
        printf "
# Shell Timeout = %s hours = %s seconds
TMOUT=%s; readonly TMOUT; export TMOUT\n" #{tmout_h} #{tmout_s} #{tmout_s} >> /etc/bash.bashrc
    EOtmout
    #not_if "grep -q ^TMOUT= /etc/bash.bashrc"
    not_if {::File.foreach("/etc/bash.bashrc").grep(/^TMOUT=/).any?}
end # of bash "Shell Timeout TMOUT setzen" do

#############################################
# UMASK restriktiv setzen
umaskrc="0077"
bash "umask restriktiv auf " + umaskrc + " setzen in bashrc" do
    user "root"
    code <<-EOumask
    printf "
# umask restriktiv setzen auf %s
umask %s\n\n" #{umaskrc} #{umaskrc} >> /etc/bash.bashrc
    EOumask
    #not_if "grep -q '^umask " + umaskrc + "' /etc/bash.bashrc"
    not_if {::File.foreach("/etc/bash.bashrc").grep(/^umask #{umaskrc}/).any?}
end # of bash "umask restrikiv auf " + umaskrc + "setzen in bashrc" do

umaskdefs="0077"
bash "umask restriktiv auf " + umaskdefs + " setzen in /etc/login.defs" do    
    user "root"
    code <<-EOumask
        perl -pi -e 's,^(UMASK.*),\n# umask restriktiv setzen auf #{umaskdefs}\n# Alt: $1\nUMASK #{umaskdefs}\n,' /etc/login.defs
    EOumask
    #not_if "grep -q '^UMASK #{umaskdefs}' /etc/login.defs"
    not_if {::File.foreach("/etc/login.defs").grep(/^UMASK #{umaskdefs}/).any?}
end # of bash "umask restrikiv auf " + umaskdefs + "setzen in /etc/login.defs" do

#############################################
# getty reduzieren
for tty_number in 3..6
    tty="tty" + tty_number.to_s

    service "Stoppy getty für " + tty do
        service_name tty
        action :stop
        only_if {::File.exist?("/etc/init/" + tty + ".conf")}
    end # of service "Stoppy getty für " + tty do

    file "Getty upstart Job entfernen: " + tty do
        path "/etc/init/" + tty + ".conf"
        action :delete
        only_if {::File.exist?("/etc/init/" + tty + ".conf")}
    end # of file "Getty upstart Job entfernen: " + tty do
end # of for tty_number in 3..6

#############################################
# CIS: AutoFS deaktivieren
service "CIS: AutoFS Dienst stoppen" do
    service_name "autofs"
    action :stop
    only_if {::File.exist?("/etc/init/autofs.conf")}
end # of service "CIS: AutoFS Dienst stoppen" do

ruby_block "CIS: AutoFS start deaktivieren" do
    block do
        fe = Chef::Util::FileEdit.new("/etc/init/autofs.conf")
        # "start on" auskommentieren
        fe.search_file_replace_line(/^(start on.*)/,
            "# removed because of CIS check:\n# \1"
            )

        # Datei schreiben
        fe.write_file
    end # of block do
    only_if {::File.exist?("/etc/init/autofs.conf")}
end # of ruby_block "CIS: AutoFS start deaktivieren" do

#############################################
# Kernel-Parameter/sysctl laden
%w[99-ew-ipv6-disable 99-ew-network-parameters].each do |sysctlfile|
    cookbook_file "Kernel-Parameter Datei anlegen: /etc/sysctl.d/" + sysctlfile + ".conf" do
        source "sysctl.d/" + sysctlfile + ".conf"
        path "/etc/sysctl.d/" + sysctlfile + ".conf"
        mode "0644"
        owner "root"
        group "root"
        action :create
    end # of cookbook_file "IPv6 deaktivieren" do

    bash "Kernel-Parameter Datei einlesen: /etc/sysctl.d/" + sysctlfile + ".conf" do
        user "root"
        code <<-EOread_sysctl_file
            sysctl -p "/etc/sysctl.d/#{sysctlfile}.conf"
            sysctl -q -w net.ipv4.route.flush=1
        EOread_sysctl_file
    end # of bash "Kernel-Parameter Datei einlesen: /etc/sysctl.d/" + sysctlfile + ".conf" do
end # of %w[99-ew-ipv6-disable 99-ew-network-parameters].each do |sysctlfile|

#############################################
# Login Banner: /etc/issue und /etc/issue
%w[issue issue.net]. each do |bannerfile|
    cookbook_file "Login Banner Datei: /etc/" + bannerfile do
        source bannerfile
        path "/etc/" + bannerfile
        mode "0644"
        owner "root"
        group "root"
        action :create
    end # of cookbook_file "Login Banner Datei: /etc/" + bannerfile do
end # of %w[issue issue.net]. each do |bannerfile|

#############################################
# System File Permissions
{"/etc/passwd" => ["root:root", "0644"], "/etc/shadow" => ["root:shadow", "0640"], "/etc/group" => ["root:root", "0644"], "/etc/gshadow" => ["root:shadow", "0640"]}.each do |filename, perms|
    file "System File Permissions anpassen: " + filename + " -> Owner: " + perms[0] + " Rechte: " + perms[1] do
        path filename
        owner perms[0].split(":")[0]
        group perms[0].split(":")[1]
        mode perms[1]
    end # of file "System File Permissions anpassen: " + filename + " -> Owner: " + perms[0] + " Rechte: " + perms[1]
end # of {"/etc/passwd" => ["root:root", "0644"], "/etc/shadow" => ["root:shadow", "0640"], "/etc/group" => ["root:root", "0644"], "/etc/gshadow" => ["root:shadow", "0640"]}.each do |filename, perms|

#############################################
# Compass SNB NG Audit
# Setuid Dateien anpassen
# https://wiki.ubuntu.com/Security/Investigation/Setuid
%w[/usr/lib/pt_chown /usr/lib/eject/dmcrypt-get-device /usr/bin/chfn].each do |setuidfile|
    # https://discourse.chef.io/t/cannot-set-permissions-with-file-resource-to-quoted-string/7259
    # file resource klappt nicht, da "u-s" nicht geht.
    # file "Setuid Berechtigung anpassen: " + setuidfile do
    #     path setuidfile
    #     mode "u-s"
    # end # of file "Setuid Berechtigung anpassen: " + setuidfile do

    execute "Setuid Berechtigung anpassen: " + setuidfile do
        command 'chmod u-s "' + setuidfile + '"'
        only_if {::File.stat(setuidfile).setuid?}
    end # of execute "Setuid Berechtigung anpassen: " + setuidfile do
end # of %w[/usr/lib/pt_chown /usr/lib/eject/dmcrypt-get-device /usr/bin/chfn].each do |setuidfile|

# EOF
