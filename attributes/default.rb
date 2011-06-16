default[:celery][:virtualenv] = nil
default[:celery][:django] = false
# celeryd specific attributes
default[:celeryd][:pid_file] = "/var/run/celeryd.pid"
default[:celeryd][:log_file] = "/var/log/celeryd.log"
default[:celeryd][:log_level] = "INFO"
default[:celeryd][:user] = nil
default[:celeryd][:group] = nil
default[:celeryd][:executable] = "celeryd" # FIXME hope it's in your path!
default[:celeryd][:chdir] = nil
default[:celeryd][:opts] =  nil
# celerybeat specific attributes
default[:celerybeat][:pid_file] = "/var/run/celerybeat.pid"
default[:celerybeat][:log_file] = "/var/log/celerybeat.log"
default[:celerybeat][:log_level] = "INFO"
default[:celerybeat][:user] = nil
default[:celerybeat][:group] = nil
default[:celerybeat][:executable] = "celerybeat" # FIXME hope it's in your path!
default[:celerybeat][:chdir] = nil
default[:celerybeat][:opts] =  nil
