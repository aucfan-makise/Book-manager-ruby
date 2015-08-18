#
# Cookbook Name:: base
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

package "httpd" 

#template "/etc/httpd/conf/httpd.conf" do
#	source "httpd.conf.erb"
#end
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
