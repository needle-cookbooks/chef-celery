@default_options = {
  'loglevel' => 'info',
  'schedule' => '/var/lib/celery/celerybeat-schedule'
}

define :celery_beat, :enable => true, :virtualenv => false, :logfile => "/var/log/celerybeat.log", :loglevel => "INFO", :startsecs => 10, :django => false, :stopwaitsecs => 600, :options => @default_options do

  case params[:enable]
  when true

    include_recipe 'supervisord'

    celery_command = String.new
    user params[:user] if params[:user]
    group params[:group] if params[:group]

    if params[:virtualenv]
      # runinenv script courtesy parente (https://gist.github.com/826961)
      cookbook_file "/usr/local/bin/runinenv" do
        source "runinenv.sh"
        owner "root"
        group "root"
        mode "0755"
      end
    end

    if params[:django]
      managepy = ::File.join(params[:django],'manage.py')
      celery_command = managepy + " celerybeat"
    else
      celery_command = "celerybeat"
    end

    if params[:virtualenv]
      celery_command = "sh /usr/local/bin/runinenv #{params[:directory]} #{celery_command}"
    end

    params[:options].each do |k,v|
      celery_command = celery_command + " --#{k}=#{v}"
    end

    Chef::Log.info("celery: generated celery_command as: " + celery_command.inspect)

    supervisord_program "celerybeat-#{params[:name]}" do
      command celery_command
      directory params[:directory]
      autostart true
      autorestart true
      user params[:user] if params[:user]
      stdout_logfile params[:logfile]
      stderr_logfile params[:logfile]
      startsecs params[:startsecs]
      stopwaitsecs params[:stopwaitsecs]
      numprocs 1
      priority 999
    end

    # supervisord should automatically start the service, but we want a service 
    # resource declared so that it will be possible to restart the celery service 
    # from inside another recipe
    
    service "celerybeat-#{params[:name]}" do
      provider Chef::Provider::Service::Init
      supports :start => true, :stop => true, :restart => true, :status => true
      start_command "supervisorctl start celerybeat-#{params[:name]}"
      stop_command "supervisorctl stop celerybeat-#{params[:name]}"
      restart_command "supervisorctl restart celerybeat-#{params[:name]}"
      status_command "supervisorctl status celerybeat-#{params[:name]}"
      action :nothing
    end

  when false
    Chef::Log.fatal("celery: the celery definition does not currently support disable action")
  end

end
