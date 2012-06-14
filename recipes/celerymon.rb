include_recipe 'runit'
include_recipe 'celery::default'

runit_service 'celerymon'

service "celerymon" do
  stop_command "sv stop celerymon"
  start_command "sv start celerymon"
end

# Install cloudkick plugin to monitor celery tasks
template "/usr/lib/cloudkick-agent/plugins/cloudkick-celerymon.py" do
  source "cloudkick-celerymon.py.erb"
  mode 0755
  action :create
end
