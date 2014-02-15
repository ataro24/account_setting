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

  bash "install mylib" do
    only_if "which git"
    user u['uname']
    cwd u['home']
    environment "HOME" => u['home']
    code <<-EOH
      git clone https://github.com/Ataro24/mylib.git
      chown -R #{u['uname']}:#{u['gname']} mylib
      cd mylib
      sh ./install.sh -f
    EOH
  end if u['mylib']

end


