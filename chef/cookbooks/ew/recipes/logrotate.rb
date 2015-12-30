#
# Cookbook Name:: ew
# Recipe:: logrotate
#
# Copyright 2015, EveryWare
#
# All rights reserved - Do Not Redistribute
#

# EveryWare Standard Logrotates

# logrotate.conf erzeugen
include_recipe 'logrotate::global'

logrotate_app 'wtmp' do
    path '/var/log/wtmp'
    options ['missingok']
    frequency 'monthly'
    create '0664 root utmp'
    rotate 1
end # of logrotate_app 'wtmp' do

logrotate_app 'btmp' do
    path '/var/log/btmp'
    options ['missingok']
    frequency 'monthly'
    create '0660 root utmp'
    rotate 1
end # of logrotate_app 'btmp' do

logrotate_app 'apt' do
    path ['/var/log/apt/term.log', '/var/log/apt/history.log']
    options ['missingok', 'compress', 'notifempty']
    frequency 'monthly'
    rotate 12
end # of logrotate_app 'apt' do

logrotate_app 'chef' do
    path '/var/log/chef/client.log'
    options ['compress']
    frequency 'weekly'
    rotate 12
    postrotate '/usr/sbin/invoke-rc.d chef-client restart > /dev/null'
end # of logrotate_app 'chef' do

logrotate_app 'dpkg' do
    path ['/var/log/dpkg.log', '/var/log/alternatives.log']
    options ['missingok', 'compress', 'delaycompress', 'notifempty']
    frequency 'monthly'
    rotate 12
    create '644 root root'
end # of logrotate_app 'dpkg' do

logrotate_app 'rsyslog-syslog' do
    path '/var/log/syslog'
    options ['missingok', 'compress', 'delaycompress', 'notifempty']
    frequency 'daily'
    rotate 7
    postrotate 'reload rsyslog >/dev/null 2>&1 || true'
end # of logrotate_app 'rsyslog syslog' do

logrotate_app 'rsyslog-common' do
    path ['/var/log/mail.info', '/var/log/mail.warn', '/var/log/mail.err', '/var/log/mail.log', '/var/log/daemon.log', '/var/log/kern.log', '/var/log/auth.log', '/var/log/user.log', '/var/log/lpr.log', '/var/log/cron.log', '/var/log/debug', '/var/log/messages']
    options ['missingok', 'compress', 'delaycompress', 'notifempty', 'sharedscripts']
    frequency 'weekly'
    rotate 4
    postrotate 'reload rsyslog >/dev/null 2>&1 || true'
end # of logrotate_app 'rsyslog common' do

logrotate_app 'upstart' do
    path '/var/log/upstart/*.log'
    options ['missingok', 'compress', 'notifempty']
    frequency 'daily'
    rotate 7
end # of logrotate_app 'upstart' do

# EOF
