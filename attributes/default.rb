default[:celery][:virtualenv] = nil
default[:celery][:version] = nil
default[:celery][:django] = false
default[:celery][:config_module] = nil
default[:celery][:logdir] = "/var/log/celery"
# celeryd specific attributes
default[:celery][:celeryd_pid_file] = "/var/run/celeryd.pid"
default[:celery][:celeryd_log_file] = "#{node[:celery][:logdir]}/celeryd.log"
default[:celery][:celeryd_log_level] = "INFO"
default[:celery][:celeryd_user] = nil
default[:celery][:celeryd_group] = nil
default[:celery][:celeryd_cmd] = "celeryd"
default[:celery][:celeryd_multi_cmd] = "celeryd_multi" 
default[:celery][:celeryctl_cmd] = "celeryctl"
default[:celery][:celeryd_chdir] = nil
default[:celery][:celeryd_opts] =  nil
# amqp specific attributes
default[:celery][:celeryd_use_amqp] = true
default[:celery][:amqp_task_result_expires] = 300
default[:celery][:amqp_task_result_connection_max] = 1
default[:celery][:amqp_result_exchange] = "celeryresults"
default[:celery][:amqp_result_exchange_type] = "direct"
default[:celery][:amqp_result_serializer] = "pickle"
default[:celery][:amqp_result_persistent] = false
# celerybeat specific attributes
default[:celery][:celerybeat_pid_file] = "/var/run/celerybeat.pid"
default[:celery][:celerybeat_log_file] = "#{node[:celery][:logdir]}/celerybeat.log"
default[:celery][:celerybeat_log_level] = "INFO"
default[:celery][:celerybeat_user] = nil
default[:celery][:celerybeat_group] = nil
default[:celery][:celerybeat_executable] = "celerybeat"
default[:celery][:celerybeat_chdir] = nil
default[:celery][:celerybeat_opts] =  nil
