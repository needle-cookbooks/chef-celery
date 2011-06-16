#
# Cookbook Name:: celery
# Recipe:: server
#
# Copyright 2011, Needle Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "celery::default"

case node[:platform]
when "ubuntu","debian"
  template "/etc/default/celerybeat" do
    source "celerybeat-default.erb"
    mode 0644
    owner "root"
    group "root"
  end

  remote_file "/etc/init.d/celerybeat" do
    source "celerybeat-init"
    mode 0755
    owner "root"
    group "root"
  end

  service "celerybeat" do
    action :enable
    supports :start => true, :stop => true, :restart => true, :status => true
  end
else
  log "recipe[celery::server] does not presently support platforms other than ubuntu and debian"
  exit
end
