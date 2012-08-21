define :celery_worker, :enable => true, :virtualenv => false, :startsecs => 10, :django => false, :stopwaitsecs => 600, :options => {} do

  case params[:enable]
  when true
    include_recipe 'python'
    include_recipe 'supervisord'

    celery_command = String.new

    unless params[:options].has_key?('loglevel')
      params[:options].merge!({'loglevel' => 'info'})
    end

    unless params[:options].has_key?('logfile')
      params[:options].merge!({'logfile' => "/var/log/celery/celeryd-#{params[:name]}.log"})
    end

    user params[:user] if params[:user]
    group params[:group] if params[:group]

    directory File.dirname(params[:options]['logfile']) do
      owner params[:user] if params[:user]
      group params[:group] if params[:group]
      mode "0755"
    end

    if params[:virtualenv]
      # runinenv script courtesy parente (https://gist.github.com/826961)
      cookbook_file "/usr/local/bin/runinenv" do
        source "runinenv.sh"
        cookbook "celery"
        owner "root"
        group "root"
        mode "0755"
      end
    end

    if params[:django]
      managepy = ::File.join(params[:django],'manage.py')
      celery_command = managepy + " celeryd --events"
    else
      celery_command = "celeryd --events"
    end

    if params[:virtualenv]
      celery_command = "sh /usr/local/bin/runinenv #{params[:virtualenv]} #{celery_command}"
    end

    params[:options].each do |k,v|
      celery_command = celery_command + " --#{k}=#{v}"
    end

    Chef::Log.debug("celery_worker: generated celery_command as: " + celery_command.inspect)

    supervisord_program "celeryd-#{params[:name]}" do
      command celery_command
      directory params[:directory]
      autostart true
      autorestart "true"
      user params[:user] if params[:user]
      stdout_logfile params[:logfile]
      stderr_logfile params[:logfile]
      startsecs params[:startsecs]
      stopwaitsecs params[:stopwaitsecs]
      priority 998
      action :supervise
    end

    # supervisord should automatically start the service, but we want a service
    # resource declared so that it will be possible to restart the celery service
    # from inside another recipe

    service "celeryd-#{params[:name]}" do
      provider Chef::Provider::Service::Simple
      supports :start => true, :stop => true, :restart => true, :status => true
      start_command "supervisorctl start celeryd-#{params[:name]}"
      stop_command "supervisorctl stop celeryd-#{params[:name]}"
      restart_command "supervisorctl restart celeryd-#{params[:name]}"
      status_command "supervisorctl status celeryd-#{params[:name]}"
      action :nothing
    end

  when false
    Chef::Log.fatal("celery: the celery definition does not currently support disable action")
  end
end
