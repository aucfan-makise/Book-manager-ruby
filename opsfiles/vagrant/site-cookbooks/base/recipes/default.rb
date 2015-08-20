#
# Cookbook Name:: base
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

package "httpd" 

template "/etc/httpd/conf.d/book_manager.conf" do
    source "book_manager.conf.erb"
end

package "curl-devel" do
    action :install
end
package "httpd-devel" do
    action :install
end

gem_package "passenger" do
    gem_binary("/usr/local/rbenv/shims/gem")
    action :install
end

bash 'install_passenger' do
    user 'root'

    code <<-EOC
      /usr/local/rbenv/versions/2.2.2/bin/passenger-install-apache2-module --auto
      /usr/local/rbenv/versions/2.2.2/bin/passenger-install-apache2-module --snippet > /etc/httpd/conf.d/passenger.conf
    EOC

    creates "/etc/httpd/conf.d/passenger.conf"
end

#passengerが入ってないとmoduleの設定がなくて怒られる
service "httpd" do
	action [:start, :enable]
end

execute "setenforce 0" do
	only_if "getenforce | grep -q Enforcing"
end

execute "Disable SELinux" do
	command "sed -ri 's/SELINUX=.*/SELINUX=disabled/' /etc/selinux/config"
	only_if "test -f /etc/selinux/config && ! grep -q 'SELINUX=disabled' /etc/selinux/config"
end

service "iptables" do
	action [:disable, :stop]
end
