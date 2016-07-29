apt_repository 'multiverse' do
  uri 'http://archive.ubuntu.com/ubuntu'
  distribution node["lsb"]["codename"]
  components ['multiverse']
  deb_src true
end

apt_repository 'updates-multiverse' do
  uri 'http://archive.ubuntu.com/ubuntu'
  distribution "#{node["lsb"]["codename"]}-updates"
  components ['multiverse']
  deb_src true
end

apt_repository 'security-multiverse-src' do
  uri 'http://security.ubuntu.com/ubuntu'
  distribution "#{node["lsb"]["codename"]}-security"
  components ['multiverse']
  deb_src true
end

include_recipe 'w_nfs::client' if node['w_apache']['nfs']['enabled']

include_recipe 'apache2'

begin
  r = resources(template: "#{node['apache']['dir']}/mods-available/fastcgi.conf")
  r.cookbook 'w_apache'
  r.source 'fastcgi.conf.erb'
  r.owner 'root'
  r.group 'root'
rescue Chef::Exceptions::ResourceNotFound
  Chef::Log.warn 'could not find template to override!'
end

include_recipe "w_apache::php_#{node['php']['install_method']}"
include_recipe 'w_apache::vhosts'

firewall 'default'

listen_ports = node['apache']['listen'].map{ |l| l.split(':').last }.uniq

listen_ports.each do |listen_port|
	firewall_rule "apache listen port #{listen_port}" do
	  port     listen_port.to_i
	  protocol :tcp
	end
end

include_recipe 'w_apache::config_test' if node['w_apache']['config_test_enabled']
include_recipe 'w_apache::monit' if node['monit_enabled']
include_recipe 'w_apache::newrelic_app' if node['w_apache']['newrelic_app_enabled']
include_recipe 'w_apache::blackfire' if node['w_apache']['blackfire_enabled']
include_recipe 'w_apache::xdebug' if node['w_apache']['xdebug_enabled']
include_recipe 'w_apache::varnish_integration' if node['w_apache']['varnish_enabled']
include_recipe 'w_apache::deploy' if node['w_apache']['deploy']['enabled']
include_recipe 'w_apache::phpmyadmin' if node['w_apache']['phpmyadmin']['enabled']
include_recipe 'w_apache::haproxydb' if node['w_apache']['haproxydb_enabled']
include_recipe 'w_apache::ssl' if node['w_apache']['ssl_enabled']
include_recipe 'w_apache::composer' if node['w_apache']['composer_enabled']
package 'mysql-client' if node['w_apache']['install_mysql_client']
