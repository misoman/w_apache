require_relative '../spec_helper'

describe 'w_apache::php_source' do

  context 'by default install php #{version} from package' do

    before do
      stub_command("test -d /etc/php5/fpm/pool.d || mkdir -p /etc/php5/fpm/pool.d").and_return(true)
    end

    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['w_common']['web_apps'] = web_apps
        #node.set['w_apache']['xdebug_enabled'] = true
      end.converge(described_recipe)
    end

    it 'creates php config directory' do
      expect(chef_run).to create_directory('conf directory while package installation').with(path: '/etc/php5/fpm', owner: 'root', group: 'root', mode: 00755, recursive: true)
      expect(chef_run).to create_directory('extra conf directory while package installation').with(path: '/etc/php5/fpm/conf.d', owner: 'root', group: 'root', mode: 00755, recursive: true)
    end

    it 'creates fpm config directory' do
      expect(chef_run).to create_directory('/etc/php5/fpm').with(owner: 'root', group: 'root', mode: 00755, recursive: true)
      expect(chef_run).to create_directory('/etc/php5/fpm/conf.d').with(owner: 'root', group: 'root', mode: 00755, recursive: true)
      expect(chef_run).to create_directory('/etc/php5/mods-available').with(owner: 'root', group: 'root', mode: 00755, recursive: true)
    end

    %w( default package ini ).each do |recipe|
      it "includes php::#{recipe} recipe" do
        expect(chef_run).to include_recipe("php::#{recipe}")
      end
    end

    it 'creates directory for php related scripts' do
      expect(chef_run).to create_directory('/usr/lib/php5').with(owner: 'root', group: 'root', mode: 00755)
    end

    %w(maxlifetime php5-fpm-checkconf php5-fpm-reopenlogs sessionclean).each do |script|
      it "creates #{script} script files" do
        expect(chef_run).to create_template("/usr/lib/php5/#{script}").with(source: "php-lib-#{script}.erb", owner: 'root', group: 'root', mode: 00755)
      end

      if script.include?('php5-fpm') then
        it "renders #{script} script with proper conf file location" do
          expect(chef_run).to render_file("/usr/lib/php5/#{script}").with_content(/\/etc\/php5\/fpm\/php-fpm.conf/)
        end
      end
    end

    %w( php5-cgi php5 php5-dev php5-cli php-pear php5-mysql php5-memcached php5-gd php5-pspell php5-curl ).each do |package|
      it "installs #{package} package" do
        expect(chef_run).to install_package(package)
      end
    end

    it 'creates fpm config file' do
      expect(chef_run).to create_template('/etc/php5/fpm/php-fpm.conf').with(source: 'php-fpm.conf.erb', owner: 'root', group: 'root', mode: 00644)
    end

    it 'creates fpm log dir and log  rotation file' do
      expect(chef_run).to create_directory('/var/log/php5-fpm').with(owner: 'root', group: 'root', mode: 00755)
      expect(chef_run).to create_template('/etc/logrotate.d/php5-fpm').with(source: 'php-fpm.logrotate.erb', owner: 'root', group: 'root', mode: 00644)
    end

    it 'creates php.ini file and generic fpm config file' do
      expect(chef_run).to create_template('/etc/php5/fpm/php.ini').with(source: 'php.ini.erb', owner: 'root', group: 'root', mode: '0644')
      expect(chef_run).to create_template('/etc/php5/fpm/php-fpm.conf').with(source: 'php-fpm.conf.erb', owner: 'root', group: 'root', mode: 00644)
    end

    it 'creates fpm pool' do
      expect(chef_run).to install_php_fpm_pool('php-fpm').with(
        max_children: 64,
        start_servers: 4,
        min_spare_servers: 4,
        max_spare_servers: 32,
        additional_config: {
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
        }
      )
    end

    it 'enables and starts service php5-fpm' do
      expect(chef_run).to enable_service('php-fpm').with(service_name: 'php5-fpm')
      expect(chef_run).to start_service('php-fpm').with(service_name: 'php5-fpm')
    end
  end

  context 'when install install php #{version} from source and enable shmop' do

    before do
      stub_command('which php').and_return(false)
    end

    let(:version) do
     '5.6.18'
    end

    configure_options = %W(--with-gmp --prefix=/usr/local --with-libdir=lib --with-config-file-path=/etc/php5/fpm --with-config-file-scan-dir=/etc/php5/fpm/conf.d --with-pear --enable-fpm --with-fpm-user=www-data --with-fpm-group=www-data --with-zlib --with-openssl --with-kerberos --with-bz2 --with-curl --enable-ftp --enable-zip --enable-exif --with-gd --enable-gd-native-ttf --with-gettext --with-mhash --with-iconv --with-imap --with-imap-ssl --enable-sockets --enable-soap --with-xmlrpc --with-libevent-dir --with-mcrypt --enable-mbstring --with-t1lib --with-mysql --with-mysqli=/usr/bin/mysql_config --with-mysql-sock --with-sqlite3 --with-pdo-mysql --with-pdo-sqlite --enable-shmop)

    let(:build_script) do
<<-EOF
  tar -zxf php-#{version}.tar.gz
  (cd php-#{version} &&  ./configure #{configure_options.join(' ')})
  (cd php-#{version} && make && make install)
  EOF
    end

    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['w_common']['web_apps'] = web_apps
        node.set['php']['install_method'] = 'source'
      end.converge(described_recipe)
    end

    it 'creates init script to manage starting or stoping fpm service' do
      expect(chef_run).to create_template('/etc/init.d/php5-fpm').with(source: 'php-fpm.init.d.erb', owner: 'root', group: 'root', mode: 00755)
    end

    it 'creates initialization configuration script for fpm service' do
      expect(chef_run).to create_template('/etc/init/php5-fpm.conf').with(source: 'php-fpm.init.conf.erb', owner: 'root', group: 'root', mode: 00644)
    end

    # keep this until https://github.com/chef-cookbooks/php/pull/80 gets merged
    it 'creates symlink to gmp.h to avoid error' do
      expect(chef_run).to create_link('/usr/include/gmp.h').with(to: '/usr/include/x86_64-linux-gnu/gmp.h')
    end

    it 'creates directory for available modules' do
      expect(chef_run).to create_directory('/etc/php5/mods-available').with(owner: 'root', group: 'root', mode: 00755, recursive: true)
    end

    describe 'include_recipe php::default' do

       %w( php::default php::source build-essential xml ).each do |recipe|
        it "includes php::#{recipe} recipe" do
          expect(chef_run).to include_recipe(recipe)
        end
      end

      it 'installs mysql client' do
        expect(chef_run).to create_mysql_client('default')
      end

      %w(libbz2-dev libc-client2007e-dev libcurl4-gnutls-dev libfreetype6-dev libgmp3-dev libjpeg62-dev libkrb5-dev libmcrypt-dev libpng12-dev libssl-dev libt1-dev).each do |package|
        it "installs #{package} package for php build" do
          expect(chef_run).to install_package(package)
        end
      end

      it 'downloads source code of php interpreter' do
        expect(chef_run).to create_remote_file("#{Chef::Config[:file_cache_path]}/php-#{version}.tar.gz").with(
          source: "http://us1.php.net/get/php-#{version}.tar.gz/from/this/mirror",
          checksum: '76da4150dc2da86b7b63b1aad3c20d1d11964796251ac0dd4d26d0a3f5045015',
          mode: '0644'
        )
      end

      it 'will not create ext dir which is for RHEL' do
        expect(chef_run).not_to create_directory('/usr/lib64/php/modules')
      end

      it 'builds php' do
        expect(chef_run).to run_bash('build php').with(cwd: Chef::Config[:file_cache_path], code: build_script)
      end

      it 'creates php config directory' do
        expect(chef_run).to create_directory('/etc/php5/fpm').with(owner: 'root', group: 'root', mode: '0755', recursive: true)
        expect(chef_run).to create_directory('/etc/php5/fpm/conf.d').with(owner: 'root', group: 'root', mode: '0755', recursive: true)
      end

      it 'includes php::ini recipe' do
        expect(chef_run).to include_recipe('php::ini')
      end
    end

    it 'creates directory for php related scripts' do
      expect(chef_run).to create_directory('/usr/lib/php5').with(owner: 'root', group: 'root', mode: 00755)
    end

    %w(maxlifetime php5-fpm-checkconf php5-fpm-reopenlogs sessionclean).each do |script|
      it "creates #{script} script files" do
        expect(chef_run).to create_template("/usr/lib/php5/#{script}").with(source: "php-lib-#{script}.erb", owner: 'root', group: 'root', mode: 00755)
      end

      if script.include?('php5-fpm') then
        it "renders #{script} script with proper conf file location" do
          expect(chef_run).to render_file("/usr/lib/php5/#{script}").with_content(/\/etc\/php5\/fpm\/php-fpm.conf/)
        end
      end
    end

    it 'creates directory for fpm pool' do
      expect(chef_run).to create_directory('/etc/php5/fpm/pool.d').with(owner: 'root', group: 'root', mode: 00755)
    end

    it 'creates fpm pool' do
      expect(chef_run).to install_php_fpm_pool('php-fpm').with(
        max_children: 64,
        start_servers: 4,
        min_spare_servers: 4,
        max_spare_servers: 32,
        additional_config: {
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
        }
      )
    end

    it 'creates fpm config file' do
      expect(chef_run).to create_template('/etc/php5/fpm/php-fpm.conf').with(source: 'php-fpm.conf.erb', owner: 'root', group: 'root', mode: 00644)
    end

    it 'creates fpm log dir and log  rotation file' do
      expect(chef_run).to create_directory('/var/log/php5-fpm').with(owner: 'root', group: 'root', mode: 00755)
      expect(chef_run).to create_template('/etc/logrotate.d/php5-fpm').with(source: 'php-fpm.logrotate.erb', owner: 'root', group: 'root', mode: 00644)
    end
  end
end
