### Description

This cookbook provides definitions which can be used to set up [Celery task queue](http://www.celeryproject.org) processes. These definitions are intended to be used as part of your own application cookbook stack; you won't get a lot of use out of them without a task broker (e.g. MongoDB or AMQP. We use RabbitMQ.) and whatever else your app requires to run.

### Requirements

Depends on the following cookbooks:

* [Opscode's `python` cookbook](http://community.opscode.com/cookbooks/python)
* [Our fork of the `supervisord` cookbook](https://github.com/needle-cookbooks/chef-supervisord/tree/needle)

### Attributes

`celery.version` - desired version of celery, defaults to nil (installs latest version)
`celerymon.version` - desired version of celery, defaults to nil (installs latest version)

### Defintions

This cookbook provides the following definitions:

* `celery_worker`
* `celery_beat`
* `celery_mon`
* `celery_cam`

Each definition configures an instance of a Celery process, managed by [supervisord](http://supervisord.org).

All of these definitions accept optional parameters for `django`, `virtualenv` and `logfile`. The `django` and `virtualenv` parameters default to false, and the `logfile` will try to generate a reasonable default using `/var/log/celery` as the base path.

The `celery_worker`, `celery_beat` and `celery_cam` definitions accept an `options` parameter which can be used to set command line flags that the processes are run with. The `celery_mon` definition does not accept this parameter.

### Usage

```
include_recipe 'celery'

django_path = '/path/to/myapp/dir' # i.e. where manage.py lives
virtualenv_path = '/path/to/virtualenv'

celery_opts = { "broker" => "amqp://guest:guest@localhost/%%2Fmyappvhost" }

celeryd_opts = {
  # have to escape the % in the vhost name with another % for supervisord
  "broker" => "amqp://guest:guest@localhost/%%2Fmyappvhost", 
  "concurrency" => 10,
  "queues" => "celery"
}

celery_worker "myapp" do
  django django_path
  virtualenv
  options celeryd_opts
end

celery_beat "myapp" do
  django django_path
  virtualenv virtualenv_path
  options celery_opts
end

celery_mon "myapp" do
  django django_path
  virtualenv virtualenv_path
end

celery_cam "myapp" do
  django django_path
  virtualenv virtualenv_path
  options celery_opts
end

```
Assuming your virtualenv, app, task broker and their dependencies are in place, this recipe would install and configure all these components on one box where the task broker is already running. 

The hash of options passed to `celery_worker` would configure a `celeryd` process running with the flags `--broker=amqp://guest:guest@localhost/ --concurrency=10 --queues=celery`.

### Changelog

* 0.1.0 - first public release, definitions for celeryd, celerybeat, celerycam and celerymon
* Darkness and strife