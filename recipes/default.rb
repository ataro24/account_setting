#
# Cookbook Name:: account_setting
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

data_ids = data_bag('user_info')

data_ids.each do |id|
  u = data_bag_item('user_info', id)
  group u['gname'] do
    group_name u['gname']
    action [:create]
  end

  user u['uname'] do
    group u['gname']
    home u['home']
    shell u['shell']
    supports :manage_home => true
    action [:create]
  end

  directory u['uname'] do
    owner u['uname']
    group u['gname']
    mode "0755"
  end

  ssh_dir_path = "#{u['home']}/.ssh"
  directory ssh_dir_path do
    owner u['uname']
    group u['gname']
    mode 0755
  end

  key_path = "#{u['home']}/.ssh/authorized_keys"
  file key_path do
    owner u['uname']
    group u['gname']
    mode "0600"
    content u['pub_key']
  end
end


