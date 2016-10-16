include_recipe 'composer'

directory 'make composer home dir' do
	path node['composer']['home_dir']
	owner 'www-data'
	group 'www-data'
	recursive true
	not_if do ::Dir.exists?(node['composer']['home_dir']) end
end