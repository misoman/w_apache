require_relative '../spec_helper'

describe 'w_apache::php' do

  context 'by default install php from package' do

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
      expect(chef_run).to create_directory('/etc/php5/fpm').with(owner: 'root', group: 'root', mode: 00751, recursive: true)
    end

    %w( default package ini ).each do |recipe|
      it "includes php::#{recipe} recipe" do
        expect(chef_run).to include_recipe("php::#{recipe}")
      end
    end

    %w( php5-cgi php5 php5-dev php5-cli php-pear php5-mysql php5-memcached php5-gd php5-pspell php5-curl ).each do |package|
      it "installs #{package} package" do
        expect(chef_run).to install_package(package)
      end
    end

    it 'enables and starts service php5-fpm' do
      expect(chef_run).to enable_service('php-fpm').with(service_name: 'php5-fpm')
      expect(chef_run).to start_service('php-fpm').with(service_name: 'php5-fpm')
    end

    it 'creates php fpm pool' do
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
          'ping.path' => 'pong',
          'request_terminate_timeout' => '320',
          'security.limit_extensions' => '.php .htm .php3 .html .inc .tpl .cfg',
          'php_value[error_log]' => '/var/log/php5-fpm/php-fpm.log'
        }
      )
    end

    it 'creates php.ini file and generic fpm config file' do
      expect(chef_run).to create_template('/etc/php5/fpm/php.ini').with(source: 'php.ini.erb', owner: 'root', group: 'root', mode: '0644')
      expect(chef_run).to create_template('/etc/php5/fpm/php-fpm.conf').with(source: 'php-fpm.conf.erb', owner: 'root', group: 'root', mode: 00644)
    end

    it 'creates fpm log dir and log  rotation file' do
      expect(chef_run).to create_directory('/var/log/php5-fpm').with(owner: 'root', group: 'root', mode: 00755)
      expect(chef_run).to create_template('/etc/logrotate.d/php5-fpm').with(source: 'php-fpm.logrotate.erb', owner: 'root', group: 'root', mode: 00644)
    end

    #it 'enables firewall and run resource firewall_rule to allow port 9000' do
    #  expect(chef_run).to install_firewall('default')
    #  expect(chef_run).to create_firewall_rule('xdebug').with(port: 9000, protocol: :tcp)
    #end
  end

  context 'when install php from source' do

    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['w_common']['web_apps'] = web_apps
        node.set['php']['install_method'] = 'source'
      end.converge(described_recipe)
    end
  end
end
