#
# Cookbook Name:: wrapper
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
#

node.set["rbenv"]["ruby"]["versions"] = ["2.0.0-p645"]
node.set["rbenv"]["ruby"]["global"] = "2.0.0-p645"


include_recipe "ruby::default"
