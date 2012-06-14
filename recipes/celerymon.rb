include_recipe 'runit'
include_recipe 'celery::default'

runit_service 'celerymon'

service "celerymon" do
  stop_command "sv stop celerymon"
  start_command "sv start celerymon"
end

