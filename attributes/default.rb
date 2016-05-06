default['apache']['default_site_enabled'] = true
default['apache']['version'] = '2.4'
default['apache']['pid_file'] = '/var/run/apache2/apache2.pid'
default['apache']['docroot_dir'] = '/var/www/html'
default['apache']['default_modules'] = %w(
  status alias auth_basic authn_core authn_file authz_core authz_groupfile
  authz_host authz_user autoindex dir env mime negotiation setenvif actions fastcgi expires cache
)

default['php']['install_method'] = 'package'
default['php']['version'] = '7.0.3' # or 5.6.18 etc
default['php']['checksum'] = '76da4150dc2da86b7b63b1aad3c20d1d11964796251ac0dd4d26d0a3f5045015'

minor_version = node['php']['version'].split('.').first(2).join('.')

standard_packages = %w(bz2 cli common curl dev enchant gd gmp imap interbase intl ldap mbstring mcrypt mysql odbc opcache pgsql phpdbg pspell readline recode soap sqlite3 sybase tidy xmlrpc xml zip).map {|package| "php#{minor_version}-#{package}"}
additional_packages = %w(amqp geoip gettext gmagick igbinary imagick mailparse memcached mongodb msgpack pear radius redis rrd smbclient ssh2 uuid yac zmq).map {|package| "php-#{package}"} # apcu, uploadprogress was removed beause it was not installed properly

default['php']['packages'] = standard_packages + additional_packages
default['php']['conf_dir'] = "/etc/php/#{minor_version}/fpm"
default['php']['ext_conf_dir']  = "#{node['php']['conf_dir']}/conf.d"
default['php']['apache_conf_dir'] = "/etc/php/#{minor_version}/apache2"
default['php']['cli_conf_dir']  = "/etc/php/#{minor_version}/cli"
default['php']['pear_dir']      = '/usr/share/php'
default['php']['session_dir']   = '/var/lib/php/session'
default['php']['upload_dir']    = '/var/lib/php/uploads'

default['php']['configure_options'] = %W(--with-gmp
                                         --prefix=#{default['php']['prefix_dir']}
                                         --with-libdir=lib
                                         --with-config-file-path=#{default['php']['conf_dir']}
                                         --with-config-file-scan-dir=#{default['php']['ext_conf_dir']}
                                         --with-pear
                                         --enable-fpm
                                         --with-fpm-user=#{default['php']['fpm_user']}
                                         --with-fpm-group=#{default['php']['fpm_group']}
                                         --with-zlib
                                         --with-openssl
                                         --with-kerberos
                                         --with-bz2
                                         --with-curl
                                         --enable-ftp
                                         --enable-zip
                                         --enable-exif
                                         --with-gd
                                         --enable-gd-native-ttf
                                         --with-gettext
                                         --with-mhash
                                         --with-iconv
                                         --with-imap
                                         --with-imap-ssl
                                         --enable-sockets
                                         --enable-soap
                                         --with-xmlrpc
                                         --with-libevent-dir
                                         --with-mcrypt
                                         --enable-mbstring
                                         --with-t1lib
                                         --with-mysql
                                         --with-mysqli=/usr/bin/mysql_config
                                         --with-mysql-sock
                                         --with-sqlite3
                                         --with-pdo-mysql
                                         --with-pdo-sqlite
                                         --enable-shmop)

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

default['php']['fpm_pooldir']  = "/etc/php/#{minor_version}/fpm/pool.d"
default['php']['fpm_default_conf']  = "/etc/php/#{minor_version}/fpm/pool.d/www.conf"
default['php']['fpm_pidfile']   = "/var/run/php/php#{minor_version}-fpm.pid"
default['php']['fpm_logfile']   = "/var/log/php#{minor_version}-fpm.log"
default['php']['fpm_rotfile']   = "/etc/logrotate.d/php#{minor_version}-fpm"
default['php']['fpm_package']   = "php#{minor_version}-fpm"
default['php']['fpm_service']   = "php#{minor_version}-fpm"
default['php']['fpm_conf']['syslog_facility']      = 'daemon'
default['php']['fpm_conf']['syslog_ident']      = 'php-fpm'
default['php']['fpm_conf']['log_level']      = 'notice'
default['php']['fpm_conf']['emergency_restart_threshold']      = '0'
default['php']['fpm_conf']['emergency_restart_interval']      = '0'
default['php']['fpm_conf']['process_control_timeout']      = '0'
default['php']['fpm_conf']['process_max']      = '0'
default['php']['fpm_conf']['process_priority']      = nil
default['php']['fpm_conf']['daemonize']      = 'yes'
default['php']['fpm_conf']['rlimit_files']      = '1024'
default['php']['fpm_conf']['rlimit_core']      = '0'
default['php']['fpm_conf']['events_mechanism']      = 'epoll'
default['php']['fpm_conf']['systemd_interval']      = '10'

default['w_memcached']['ips'] = ['127.0.0.1']
default['php']['session_dir'] = node['w_memcached']['ips'].join(':11211,') + ':11211'
default['php']['mysql_module_edition'] = 'mysql'

default['xdebug']['config_file'] = "/etc/php/#{minor_version}/mods-available/xdebug.ini"
default['xdebug']['execute_php5enmod'] = true
default['xdebug']['web_server']['service_name'] = node['php']['fpm_service']
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
default['w_apache']['deploy']['enable_repo_hostsfile'] = true
default['w_apache']['newrelic_app_enabled'] = false
default['w_apache']['newrelic']['app_name'] = 'PHP Application'

default['w_apache']['blackfire_enabled'] = false
default['w_apache']['composer_enabled'] = false
default['w_apache']['install_mysql_client'] = true
default['blackfire']['php']['ini_path'] = "/etc/php/#{minor_version}/mods-available/blackfire.ini"
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
