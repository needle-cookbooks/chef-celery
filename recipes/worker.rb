#
# Cookbook Name:: celery
# Recipe:: worker
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

  remote_file "/etc/init.d/celeryd" do
    source "celeryd-init"
    mode 0755
    owner "root"
    group "root"
  end

  service "celeryd" do
    action :enable
    supports :start => true, :stop => true, :restart => true, :status => true
  end

  template "/etc/default/celeryd" do
    source "celeryd-defaults.erb"
    mode 0644
    owner "root"
    group "root"
    notifies :restart, "service[celeryd]", :delayed
  end
else
  log "recipe[celery::server] does not presently support platforms other than ubuntu and debian"
  exit
end
