require_relative '../spec_helper'

describe 'w_apache::php_package' do

  php_versions.each do |version|

    minor_version = version[:minor]

    context "install php #{minor_version} from package" do

      before do
        stub_command("test -d /etc/php5/fpm/pool.d || mkdir -p /etc/php5/fpm/pool.d").and_return(true)
      end

      let(:chef_run) do
        ChefSpec::SoloRunner.new do |node|
          node.set['w_common']['web_apps'] = web_apps
          node.set['php']['version'] = version[:full]
        end.converge(described_recipe)
      end

      it 'creates version identifier for serverspec test' do
        expect(chef_run).to create_file('/var/php_version_intended_to_be_installed_by_chef').with_content(minor_version)
      end

      it 'add apt repository for php' do
        expect(chef_run).to add_apt_repository('php').with(uri: 'ppa:ondrej/php', distribution: 'trusty')
      end

      { doc_dir: '/docs', php_dir: '', cfg_dir: '/cfg', data_dir: '/data', test_dir: '/tests', www_dir: '/www'}.each do |key, value|
        it "configures pear #{key}" do
          expect(chef_run).to run_execute("pear config-set #{key} /usr/share/php#{value}")
        end
      end

      it 'updates pear and peck channel' do
        expect(chef_run).to update_php_pear_channel('pear.php.net')
        expect(chef_run).to update_php_pear_channel('pecl.php.net')
      end

      standard_packages = %w(bz2 cli common curl dev enchant gd gmp imap interbase intl ldap mbstring mcrypt mysql odbc opcache pgsql phpdbg pspell readline recode soap sqlite3 sybase tidy xml xmlrpc zip).map {|p| "php#{minor_version}-#{p}"}
      additional_packages = %w(amqp geoip gettext gmagick igbinary imagick mailparse memcached mongodb msgpack pear radius redis rrd smbclient ssh2 uuid yac zmq).map {|p| "php-#{p}"}

      ( standard_packages + additional_packages ).each do |package|
        it "installs #{package} package" do
          expect(chef_run).to install_package(package)
        end
      end

      %W( php#{minor_version}-bcmath php#{minor_version}-xsl php#{minor_version}-json php#{minor_version}-cgi php#{minor_version}-snmp php-apcu php-ast php-uploadprogress libapache2-mod-php ).each do |package|
        it "installs #{package} package" do
          expect(chef_run).not_to install_package(package)
        end
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
            'php_value[error_log]' => "/var/log/php#{minor_version}-fpm.log"
          }
        )
      end

      it 'creates php.ini file and generic fpm config file' do
        expect(chef_run).to create_template("/etc/php/#{minor_version}/cli/php.ini").with(source: 'php.ini.erb', owner: 'root', group: 'root', mode: '0644')
        expect(chef_run).to create_template("/etc/php/#{minor_version}/fpm/php.ini").with(source: 'php.ini.erb', owner: 'root', group: 'root', mode: '0644')
        expect(chef_run).to create_template("/etc/php/#{minor_version}/fpm/php-fpm.conf").with(source: 'php-fpm.conf.erb', owner: 'root', group: 'root', mode: 00644)
      end

      if minor_version == '5.6' then
        it 'switch php 7.0 binary link to 5.6' do
          expect(chef_run).to create_link('/etc/alternatives/php').with(to: '/usr/bin/php5.6', owner: 'root', group: 'root', mode: 00777)
        end
      end

      it 'enables and starts service php5-fpm' do
        expect(chef_run).to enable_service("php#{minor_version}-fpm")
        expect(chef_run).to start_service("php#{minor_version}-fpm")
      end

      it 'do not include phalcon recipe by default as not everyone use it' do
        expect(chef_run).not_to include_recipe('w_apache::phalcon')
      end
    end

    context 'with phalcon enabled' do

      before do
        stub_command('test -e /usr/local/bin/zephir').and_return(false)
      end

      let(:chef_run) do
        ChefSpec::SoloRunner.new do |node|
          node.set['w_common']['web_apps'] = web_apps
          node.set['w_varnish']['node_ipaddress_list'] = ["7.7.7.7", "8.8.8.8"]
          node.set['php']['version'] = version[:full]
          node.set['w_apache']['phalcon_enabled'] = true
        end.converge(described_recipe)
      end

      it 'include phalcon recipe if enabled' do
        expect(chef_run).to include_recipe('w_apache::phalcon')
      end
    end
  end
end
