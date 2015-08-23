#
# Cookbook Name:: torrentbox
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'apt::default'
include_recipe 'git::default'

# Mount Disks
node['torrentbox']['disks'].each do |disk|
  directory disk['path'] do
    action :create
  end

  log "Mounting #{disk['path']}"
  mount disk['path'] do
    device disk['device']
    device_type disk['device_type']
    fstype disk['fstype']
    options disk['options']
    action [:mount, :enable]
    ignore_failure true
    not_if { ::File.directory?('/vagrant') }
  end
end

# Setup mhddfs
include_recipe 'torrentbox::mhddfs'

# Install Dashboard
include_recipe 'torrentbox::dashboard'

# Install SickRage, CouchPotato
include_recipe 'torrentbox::mediamanagement'

############################################
## Setup fileshare user
############################################

user 'DownloadManager' do
  comment 'Samba Test User'
  home '/home/DownloadManager'
  shell '/bin/bash'
end

include_recipe 'samba::server'
