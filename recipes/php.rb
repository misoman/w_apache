source_install = node['php']['install_method'] == 'source'

directory '/usr/lib/php5' do
  owner 'root'
  group 'root'
  mode 00751
  only_if { source_install }
end

template '/usr/lib/php5/php5-fpm-checkconf' do
  source 'php-fpm-checkconf.erb'
  owner 'root'
  group 'root'
  mode 00751
  only_if { source_install }
end

template '/etc/init.d/php5-fpm' do
  source 'php-fpm.init.d.erb'
  owner 'root'
  group 'root'
  mode 00751
  only_if { source_install }
end

template '/etc/init/php5-fpm.conf' do
  source 'php-fpm.init.conf.erb'
  owner 'root'
  group 'root'
  mode 00751
  only_if { source_install }
end

# work around until https://github.com/chef-cookbooks/php/pull/80 gets merged
link '/usr/include/gmp.h' do
  to '/usr/include/x86_64-linux-gnu/gmp.h'
  only_if { source_install and node['platform_version'].eql? '14.04' }
end

directory 'conf directory while package installation' do
  path node['php']['conf_dir']
  owner 'root'
  group 'root'
  mode 00755
  recursive true
  not_if { source_install }
end

directory 'extra conf directory while package installation' do
  path node['php']['ext_conf_dir']
  owner 'root'
  group 'root'
  mode 00755
  recursive true
  not_if { source_install }
end

directory '/etc/php5/mods-available' do
  owner 'root'
  group 'root'
  mode 00751
  recursive true
end

include_recipe 'php::default'

directory '/etc/php5/fpm/pool.d' do
  owner 'root'
  group 'root'
  mode 00751
  only_if { source_install }
end

php_fpm_pool 'php-fpm' do
  max_children 64
  start_servers 4
  min_spare_servers 4
  max_spare_servers 32
  additional_config({
    'catch_workers_output' => 'no',
    'listen.owner' => 'root',
    'listen.group' => 'root',
    'listen.mode' => '0666',
    'pm.max_requests' => '10000',
    'pm.status_path' => '/fpm-status',
    'ping.path' => '/fpm-ping',
    'ping.response' => 'pong',
    'request_terminate_timeout' => '320',
    'security.limit_extensions' => '.php .htm .php3 .html .inc .tpl .cfg',
    'php_value[error_log]' => '/var/log/php5-fpm/php-fpm.log'
  })
end

template "#{node['php']['conf_dir']}/php-fpm.conf" do
  source 'php-fpm.conf.erb'
  owner 'root'
  group 'root'
  notifies :restart, "service[php-fpm]"
  mode 00644
end

directory node['php']['fpm_log_dir'] do
  owner 'root'
  group 'root'
  mode 00755
  action :create
end

template node['php']['fpm_rotfile'] do
  source 'php-fpm.logrotate.erb'
  owner 'root'
  group 'root'
  mode 00644
end

service 'php-fpm' do
  service_name 'php5-fpm'
  action [:enable, :start]
  provider(Chef::Provider::Service::Upstart)if (platform?('ubuntu') && node['platform_version'].to_f >= 14.04)
end

if node['w_apache']['xdebug_enabled'] then

  include_recipe 'xdebug'

	firewall 'default'

  firewall_rule 'xdebug' do
    port     9000
    protocol :tcp
  end
end
