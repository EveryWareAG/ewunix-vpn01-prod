#!/bin/sh

# This file is managed by Chef on node <%= node[:hostname] %> 
# in <%= cookbook_name %>::<%= recipe_name %>.
# Manual changes might get lost!

# Set up iptables NAT rules as needed.
/sbin/iptables -t nat -A POSTROUTING -s <%= node['openvpn']['subnet'] %>/<%= node['openvpn']['netmask'] %> -o <%= node['network']['default_interface'] %> -j MASQUERADE

# EOF
