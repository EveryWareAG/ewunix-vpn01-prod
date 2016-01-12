# http://serverfault.com/questions/126298/idiomatic-way-to-invoke-chef-solo
# => Datei als /etc/chef/solo.rb ablegen

# https://docs.chef.io/config_rb_solo.html
# https://docs.chef.io/config_rb_client.html

require 'rubygems'
require 'ohai'
o = Ohai::System.new
o.all_plugins

local_mode					true
chef_zero.enabled			true
chef_zero.port				10000-20000

file_cache_path             "/var/chef/cache"
file_backup_path            "/var/chef/backup"

cookbook_path               [ "/opt/ew/git/chef/cookbooks", "/opt/kitchen/chef/cookbooks" ]
role_path                   "/opt/kitchen/chef/roles"
json_attribs                "/opt/kitchen/chef/nodes/#{o[:hostname]}.json"
#recipe_url                  "http://www.example.com/chef-solo.tar.gz"

environment_path            "/opt/kitchen/chef/environments"
data_bag_path               "/opt/kitchen/chef/data_bags"
encrypted_data_bag_secret   "/opt/kitchen/chef/data_bag_key"

ssl_verify_mode             :verify_peer

log_level                   :info
log_location                "/var/log/chef-zero.log"

