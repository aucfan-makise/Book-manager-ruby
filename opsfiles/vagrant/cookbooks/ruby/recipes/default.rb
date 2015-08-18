#
# Cookbook Name:: ruby
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

group "rbenv" do
    action :create
    members "vagrant"
    append true
end

git "/usr/local/rbenv" do
    repository "git://github.com/sstephenson/rbenv.git"
    reference "master"
    action :checkout
    user "root"
    group "rbenv"
end

template "/etc/profile.d/rbenv.sh" do
    owner "root"
    group "root"
    mode 0644
end

directory "/usr/local/rbenv/plugins" do
    owner "root"
    group "rbenv"
    mode "0755"
    action :create
end

git "/usr/local/rbenv/plugins/ruby-build" do
    repository "git://github.com/sstephenson/ruby-build.git"
    reference "master"
    action :checkout
    user "root"
    group "rbenv"
end

(node.set["rbenv"]["ruby"]["versions"]).each do |ruby_version|
    execute "install ruby #{ruby_version}" do
        not_if "source /etc/profile.d/rbenv.sh; rbenv versions | grep #{ruby_version}"
        command "source /etc/profile.d/rbenv.sh; rbenv install #{ruby_version}"
        action :run
    end
end

(node.set["rbenv"]["ruby"]["versions"]).each do |global_ruby|
    execute "set global ruby" do
        not_if "source /etc/profile.d/rbenv.sh; rbenv global | grep #{global_ruby}"
        command "source /etc/profile.d/rbenv.sh; rbenv global #{node.set["rbenv"]["ruby"]["global"]}; rbenv rehash"
        action :run
    end
end

