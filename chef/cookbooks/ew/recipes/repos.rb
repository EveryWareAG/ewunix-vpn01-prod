#
# Cookbook Name:: ew
# Recipe:: repos
#
# Copyright 2016, EveryWare
#
# All rights reserved - Do Not Redistribute
#

# EveryWare Standard Repositories nutzen

# apt/sources.list Datei entfernen
file "sources.list Datei entfernen" do
    path "/etc/apt/sources.list"
    action :delete
end # file "sources.list Datei entfernen" do

# Ubuntu Repositories
dist = node['lsb']['codename']
apt_repository "Ubuntu Repos: " + dist do
    name "Ubuntu-Repositories-" + dist
    uri "http://ubuntu.everyware/" + node['ew'][:aptweek] + "/ubuntu"
    distribution dist
    components ["main", "restricted", "multiverse", "universe"]
    deb_src true
end # of apt_repository "Ubuntu Repos: " + distribution do
%w{updates backports security}.each do |dist_subtype|
    dist = node['lsb']['codename'] + dist_subtype
    apt_repository "Ubuntu Repos: " + dist do
        name "Ubuntu-Repositories-" + dist
        uri "http://ubuntu.everyware/" + node['ew'][:aptweek] + "/ubuntu"
        distribution dist
        components ["main", "restricted", "multiverse", "universe"]
        deb_src true
    end # of apt_repository "Ubuntu Repos: " + distribution do
end # of %w{updates backports security}.each do |dist_subtype|

# # "ew" Repository einbinden (u.a. für SysView)
# apt_repository "ew" do
#     # deb http://ubuntu.everyware/<%= node['ew'][:aptweek] %>/ew trusty main
#     uri "http://ubuntu.everyware/" + node['ew'][:aptweek] + "/ew"
#     distribution node['lsb']['codename']
#     components ["main"]
#     key "http://ubuntu.everyware/current/keys/ew-repo_7CF7F04D.key"
# end # of apt_repository "ew" do

