#
# Cookbook Name:: ew
# Recipe:: lxc
#
# Copyright 2015, EveryWare
#
# All rights reserved - Do Not Redistribute
#

# Recipe, welches Sachen macht, die NUR in einem LXC Container zu tun sind.
# Es ist safe, das Recipe immer drin zu haben.
# Cf. http://stackoverflow.com/questions/20010199/determining-if-a-process-runs-inside-lxc-docker

# Folgendes nur dann machen, wenn IPA auf der Node schon initialisiert wurde.
if `grep :/lxc/ /proc/self/cgroup` == ""
    Chef::Log.info("Sind nicht in einem LXC Container. Recipe #{recipe_name} in Cookbook #{cookbook_name} wird nicht ausgeführt.")
    return
end # of if `grep :/lxc/ /proc/self/cgroup` == ""

# In einem LXC Container wird der NTP Dienst nicht benötigt.
service "ntp" do
    supports :status => true, :restart => true, :reload => true
    action [ :disable, :stop ]
end # of service "ntp" do

# EOF
