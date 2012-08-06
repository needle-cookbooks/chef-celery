define :celeryd_node
	include_recipe 'runit'

	#user params[:user]
	#group params[:group]

	template "/etc/defaults/celeryd-#{params['name']}" do
		source 'celeryd-defaults.erb'
		mode 0700
		variables({ :options => params[:options] })
	end

end