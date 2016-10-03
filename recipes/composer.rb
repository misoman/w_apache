include_recipe 'composer'

directory "make sure ownership and existance of composer home dir #{node['w_apache']['home']}/composer" do
	path "#{node['w_apache']['home']}/composer"
	owner node['w_apache']['owner']
	group node['w_apache']['group']
	recursive true
	not_if do ::Dir.exists?("#{node['w_apache']['home']}/composer") end
end