include_recipe 'monit'

if node['recipes'].include?('celery::worker') or node['recipes'].include?('celery::celeryd')
  monitrc 'celeryd' do
    source 'monit-celeryd.conf.erb'
    cookbook 'celery'
  end
end

if node['recipes'].include?('celery::scheduler') or node['recipes'].include?('celery::celerybeat')
  monitrc 'celerybeat' do
    source 'monit-celerybeat.conf.erb'
    cookbook 'celery'
  end
end

if node['recipes'].include?('celery::celerycam')
  monitrc 'celerycam' do
    source 'monit-celerycam.conf.erb'
    cookbook 'celery'
  end
end

if node['recipes'].include?('celery::celerymon')
  monitrc 'celerymon' do
    source 'monit-celerymon.conf.erb'
    cookbook 'celery'
  end
end
