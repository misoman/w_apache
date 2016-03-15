minor_version = node['php']['version'].split('.').first(2).join('.')

file '/var/php_version_intended_to_be_installed_by_chef' do
  content minor_version
end

apt_repository 'php' do
  uri 'ppa:ondrej/php'
  distribution node["lsb"]["codename"]
end

node['php']['packages'].each do |pkg|
  package pkg do
    action :install
    options node['php']['package_options']
  end
end

{ doc_dir: '/docs', php_dir: '', cfg_dir: '/cfg', data_dir: '/data', test_dir: '/tests', www_dir: '/www'}.each do |key, value|
  execute "pear config-set #{key} /usr/share/php#{value}"
end

php_pear_channel 'pear.php.net' do
  action :update
end

php_pear_channel 'pecl.php.net' do
  action :update
end

php_fpm_pool 'php-fpm' do
  listen "/var/run/php/php#{minor_version}-fpm.sock"
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
    'php_value[error_log]' => node['php']['fpm_logfile']
  })
end

template "/etc/php/#{minor_version}/fpm/php-fpm.conf" do
  source 'php-fpm.conf.erb'
  owner 'root'
  group 'root'
  mode 00644
  notifies :restart, "service[#{node['php']['fpm_service']}]"
end

include_recipe 'php::ini'

link '/etc/alternatives/php' do
  to '/usr/bin/php5.6'
  owner 'root'
  group 'root'
  mode 00777
  only_if { minor_version == '5.6' }
end

service node['php']['fpm_service'] do
  action [:start, :enable]
end
