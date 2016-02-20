default['apache']['default_site_enabled'] = true
default['apache']['version'] = '2.4'
default['apache']['pid_file'] = '/var/run/apache2/apache2.pid'
default['apache']['docroot_dir'] = '/var/www/html'
default['apache']['default_modules'] = %w(
  status alias auth_basic authn_core authn_file authz_core authz_groupfile
  authz_host authz_user autoindex dir env mime negotiation setenvif actions fastcgi expires cache
)
default['php']['packages']      = %w( php5-cgi php5 php5-dev php5-cli php-pear php5-mysql php5-memcached php5-gd php5-pspell php5-curl )

default['php']['conf_dir'] = '/etc/php5/fpm'
default['php']['apache_conf_dir'] = '/etc/php5/apache2'
default['php']['cgi_conf_dir']  = '/etc/php5/cgi'
default['php']['ext_conf_dir']  = '/etc/php5/conf.d'
default['php']['pear_dir']      = '/usr/share/php'
default['php']['session_dir']   = '/var/lib/php5/session5'
default['php']['upload_dir']    = '/var/lib/php5/uploads'

default['php']['ini']['cookbook'] = 'w_apache'

default['php']['secure_functions']['disable_functions'] = 'dl,posix_kill,posix_mkfifo,posix_setuid,proc_close,proc_open,proc_terminate,shell_exec,system,leak,posix_setpgid,posix_setsid,proc_get_status,proc_nice,show_source,virtual,proc_terminate,inject_code,define_syslog_variables,syslog,posix_uname'
default['php']['ini_settings'] = {
  'short_open_tag' => 'On',
  'open_basedir' => '',
  'max_execution_time' => '300',
  'max_input_time' => '300',
  'memory_limit' => '128M',
  'error_reporting' => 'E_ALL & ~E_DEPRECATED & ~E_NOTICE',
  'display_errors' => 'Off',
  'error_log' => '',
  'register_globals' => 'Off',
  'register_long_arrays' => 'Off',
  'post_max_size' => '32M',
  'magic_quotes_gpc' => 'Off',
  'always_populate_raw_post_data' => 'Off',
  'cgi.fix_pathinfo' => '1',
  'upload_max_filesize' => '32M',
  'allow_url_fopen' => 'On',
  'allow_url_include' => 'Off',
  'date.timezone' => 'UTC',
  'session.save_handler' => 'memcached',
  'session.cookie_httponly' => '0'
}
default['php']['ini_settings']['session.cookie_domain'] = '.' + node['w_common']['web_apps'][0]['vhost']['main_domain']
default['php']['directives'] = {}

default['php']['fpm_pool_dir']  = '/etc/php5/fpm/pool.d'
default['php']['fpm_log_dir']   = '/var/log/php5-fpm'
default['php']['fpm_pidfile']   = '/var/run/php5-fpm.pid'
default['php']['fpm_logfile']   = '/var/log/php5-fpm/fpm-master.log'
default['php']['fpm_rotfile']   = '/etc/logrotate.d/php5-fpm'
default['w_memcached']['ips'] = ['127.0.0.1']
default['php']['session_dir'] = node['w_memcached']['ips'].join(':11211,') + ':11211'
default['php']['mysql_module_edition'] = 'mysql'

default['xdebug']['config_file'] = '/etc/php5/mods-available/xdebug.ini'
default['xdebug']['execute_php5enmod'] = true
default['xdebug']['web_server']['service_name'] = 'php5-fpm'
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
default['w_apache']['composer_enabled'] = false
default['w_apache']['install_mysql_client'] = true
default['blackfire']['php']['ini_path'] = '/etc/php5/fpm/conf.d/blackfire.ini'
default['w_apache']['ssl_enabled'] = false
default['w_apache']['phpmyadmin']['enabled'] = false

default['phpmyadmin']['fpm'] = false
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
