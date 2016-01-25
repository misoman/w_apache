default['apache']['default_site_enabled'] = true
default['apache']['version'] = '2.4'
default['apache']['pid_file'] = '/var/run/apache2/apache2.pid'
default['apache']['docroot_dir'] = '/var/www/html'
default['apache']['default_modules'] = %w(
  status alias auth_basic authn_core authn_file authz_core authz_groupfile
  authz_host authz_user autoindex dir env mime negotiation setenvif actions fastcgi expires cache
)
default['php']['ext_conf_dir'] = '/etc/php5/mods-available'
default['php']['ini_settings']['session.save_handler'] = 'memcached'
default['php']['ini_settings']['session.cookie_domain'] = '.' + node['w_common']['web_apps'][0]['vhost']['main_domain']
default['php']['session_dir'] = node['w_memcached']['ips'].join(':11211,') + ':11211'
default['php']['mysql_module_edition'] = 'mysql'
default['xdebug']['config_file'] = '/etc/php5/mods-available/xdebug.ini'
default['xdebug']['execute_php5enmod'] = true
default['xdebug']['web_server']['service_name'] = 'php-fpm'
default['xdebug']['directives'] = {
  'remote_enable' => 'on',
  'idekey' => 'vagrant',
  'remote_handler' => 'dbgp',
  'remote_mode' => 'req',
  'remote_host' => '192.168.33.1',
  'remote_port' => '9000'
  }
default['w_apache']['xdebug_enabled'] = false
default['w_apache']['varnish_enabled'] = true
default['w_apache']['deploy']['enabled'] = false
default['w_apache']['newrelic_app_enabled'] = false
default['w_apache']['newrelic']['app_name'] = 'PHP Application'
default['w_apache']['blackfire_enabled'] = false
default['blackfire']['php']['ini_path'] = '/etc/php5/fpm/conf.d/blackfire.ini'
default['w_apache']['ssl_enabled'] = false
default['w_apache']['phpmyadmin']['enabled'] = false

default['phpmyadmin']['home'] = '/websites/phpmyadmin'
default['phpmyadmin']['home_alias'] = '/phpmyadmin'
default['phpmyadmin']['version'] = '4.4.2'
default['phpmyadmin']['checksum'] = 'e71684eebb451c70a9012452b53e60a9cd8e4679c630120b0e3a6e8607d6d37d'
default['phpmyadmin']['config_template_cookbook'] = 'w_apache'
default['phpmyadmin']['stand_alone'] = false

default['w_apache']['nfs']['enabled'] = false
default['w_apache']['nfs']['data_dir_name'] = 'data'

default['w_apache']['haproxydb_enabled'] = false
default['haproxy']['mode'] = 'tcp'
default['haproxy']['incoming_port'] = 3306
default['haproxy']['admin']['address_bind'] = '0.0.0.0'
default['haproxy']['defaults_options'] = ["tcplog", "dontlognull", "redispatch"]
default['haproxy']['httpchk'] = ''
default['haproxy']['pool_members_option'] = 'port 9200 inter 1200 rise 3 fall 3'
