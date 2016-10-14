include_recipe 'composer'

directory 'make composer home dir' do
	path node['composer']['home_dir']
	owner node['apache']['user']
	group node['apache']['group']
	recursive true
	not_if do ::Dir.exists?(node['composer']['home_dir']) end
end