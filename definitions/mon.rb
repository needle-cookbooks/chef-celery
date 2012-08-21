define :celery_mon, :enable => true, :virtualenv => false, :startsecs => 10, :django => false, :stopwaitsecs => 600, :options => {} do

  case params[:enable]
  when true
    include_recipe 'python'
    include_recipe 'supervisord'

    celery_command = String.new

    user params[:user] if params[:user]
    group params[:group] if params[:group]

    directory File.dirname(params[:logfile]) do
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
      celery_command = managepy + " celerymon"
    else
      celery_command = "celerymon"
    end

    if params[:virtualenv]
      celery_command = "sh /usr/local/bin/runinenv #{params[:virtualenv]} #{celery_command}"
    end

    params[:options].each do |k,v|
      celery_command = celery_command + " --#{k}=#{v}"
    end

    Chef::Log.debug("celery_mon: generated celery_command as: " + celery_command.inspect)

    python_pip 'celerymon' do
      version node[:celery][:version] unless node[:celery][:version].nil?
      virtualenv params[:virtualenv] if params[:virtualenv]
      action :install
    end

    supervisord_program "celerymon-#{params[:name]}" do
      command celery_command
      directory params[:directory]
      autostart true
      autorestart "true"
      user params[:user] if params[:user]
      stdout_logfile params[:logfile]
      stderr_logfile params[:logfile]
      startsecs params[:startsecs]
      stopwaitsecs params[:stopwaitsecs]
      numprocs 1
      priority 999
      action :supervise
    end

    # supervisord should automatically start the service, but we want a service 
    # resource declared so that it will be possible to restart the celery service 
    # from inside another recipe
    
    service "celerymon-#{params[:name]}" do
      provider Chef::Provider::Service::Simple
      supports :start => true, :stop => true, :restart => true, :status => true
      start_command "supervisorctl start celerymon-#{params[:name]}"
      stop_command "supervisorctl stop celerymon-#{params[:name]}"
      restart_command "supervisorctl restart celerymon-#{params[:name]}"
      status_command "supervisorctl status celerymon-#{params[:name]}"
      action :nothing
    end

  when false
    Chef::Log.fatal("celery: the celery definition does not currently support disable action")
  end

end
