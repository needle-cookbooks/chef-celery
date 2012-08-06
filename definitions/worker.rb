define :celery_worker, :enable => true, :virtualenv => false, :logfile => "/var/log/celeryd.log", :loglevel => "INFO", :startsecs => 10, :django => false, :stopwaitsecs => 600, :options => {} do

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
        cookbook "celery"
        owner "root"
        group "root"
        mode "0755"
      end
    end

    if params[:django]
      managepy = ::File.join(params[:django],'manage.py')
      celery_command = managepy + " celeryd --loglevel " + params[:loglevel]
    else
      celery_command = "celeryd --loglevel " + params[:loglevel]
    end

    if params[:virtualenv]
      celery_command = "sh /usr/local/bin/runinenv #{params[:virtualenv]} #{celery_command}"
    end

    params[:options].each do |k,v|
      celery_command = celery_command + " --#{k}=#{v}"
    end

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
  when false
    Chef::Log.fatal("celery: the celery definition does not currently support disable action")
  end
end
