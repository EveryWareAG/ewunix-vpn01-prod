# http://serverfault.com/questions/126298/idiomatic-way-to-invoke-chef-solo
# => Datei als /etc/chef/solo.rb ablegen

require 'rubygems'
require 'ohai'
o = Ohai::System.new
o.all_plugins

file_cache_path             "/opt/kitchen/chef"
cookbook_path               "/opt/kitchen/chef/cookbooks"
role_path                   "/opt/kitchen/chef/roles"
json_attribs                "/opt/kitchen/chef/nodes/#{o[:hostname]}.json"
#recipe_url                  "http://www.example.com/chef-solo.tar.gz"

#cookbook_path               [ "/opt/ew/git/chef/cookbooks" ]
#role_path                   "/opt/ew/git/chef/roles"
environment_path            "/opt/kitchen/chef/environments"
data_bag_path               "/opt/kitchen/chef/data_bags"
encrypted_data_bag_secret   "/opt/kitchen/chef/data_bag_key"
ssl_verify_mode             :verify_peer

log_level                   :info
log_location                "/var/log/chef-zero.log"
