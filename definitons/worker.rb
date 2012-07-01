define :celery_worker, :action => :enable, :virtualenv => false, :logfile => "/var/log/celeryd-#{params[:name]}", :loglevel => "INFO", :startsecs => 10, :django => false, :stopwaitsecs => 600, :options => {} do

  case params[:action]
  when :enable
    include_recipe 'supervisord'

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
      @celery_command = managepy + " celeryd --loglevel " + params[:loglevel]
    else
      @celery_command = "celeryd --loglevel " + params[:loglevel]
    end

    if params[:virtualenv]
      @celery_command = "sh /usr/local/bin/runinenv #{params[:directory]} #{@celery_command}"
    end

    supervisord_program "celeryd-#{params[:name]}" do
      command @celery_command
      directory params[:directory]
      autostart true
      autorestart true
      user params[:user] if params[:user]
      stdout_logfile params[:logfile]
      stderr_logfile params[:logfile]
      startsecs params[:startsecs]
      stopwaitsecs params[:stopwaitsecs]
      priority 998
    end
  when :disable
    Chef::Log.fatal("celery: the celery definition does not currently support disable action")
  end
end