include_recipe 'runit'
include_recipe 'celery::default'

runit_service 'celerycam'

service "celerycam" do
  stop_command "sv stop celerycam"
  start_command "sv start celerycam"
end
