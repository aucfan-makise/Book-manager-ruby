#
# Cookbook Name:: before
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

#アップデートしてないとepelが使えない罠
package 'nss' do
    action :upgrade
end
