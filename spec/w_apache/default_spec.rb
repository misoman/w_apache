require_relative '../spec_helper'

describe 'w_apache::default' do

  php_versions.each do |version|

    minor_version = version[:minor]

    context "install aapche2 with php #{minor_version} " do

      before do
        stub_command("/usr/sbin/apache2 -t").and_return(true)
      end

      context 'with Ubuntu 14.04 trusty' do
        let(:chef_run) do
          ChefSpec::SoloRunner.new do |node|
            node.set['w_memcached']['ips'] = ['127.0.0.1']
            node.set['w_common']['web_apps'] = web_apps
            node.set['w_varnish']['node_ipaddress_list'] = ["7.7.7.7", "8.8.8.8"]
            node.set['php']['version'] = version[:full]
          end.converge(described_recipe)
        end

        it 'adds apt repository multiverse, updates-multiverse, security-multiverse-src, php55 and apache2' do
          expect(chef_run).to add_apt_repository('multiverse').with(uri: 'http://archive.ubuntu.com/ubuntu', components: ['multiverse'], distribution: 'trusty', deb_src: true)
          expect(chef_run).to add_apt_repository('updates-multiverse').with(uri: 'http://archive.ubuntu.com/ubuntu', components: ['multiverse'], distribution: 'trusty-updates', deb_src: true)
          expect(chef_run).to add_apt_repository('security-multiverse-src').with(uri: 'http://security.ubuntu.com/ubuntu', components: ['multiverse'], distribution: 'trusty-security', deb_src: true)
        end

        it 'runs recipe apache2' do
          expect(chef_run).to include_recipe('apache2')
        end

        it 'creates fastcgi.conf file from w_apache/templates/default/fastcgi.conf.erb' do
          expect(chef_run).to render_file('/etc/apache2/mods-available/fastcgi.conf').with_content { |content|
            expect(content).to include('DirectoryIndex index.htm index.html index.php')
            expect(content).to include('AddHandler php-fcgi .php .htm .php3 .html .inc .tpl .cfg')
            expect(content).to include('AddType text/html .php')
            expect(content).to include('Action php-fcgi /php-fcgi')
            expect(content).to include("Alias /php-fcgi /usr/lib/cgi-bin/php#{minor_version}")
            expect(content).to include("FastCgiExternalServer /usr/lib/cgi-bin/php#{minor_version}")
          }
        end

        it 'runs recipe w_apache::php, and w_apache::vhosts' do
          expect(chef_run).to include_recipe('w_apache::php_package')
          expect(chef_run).to include_recipe('w_apache::vhosts')
        end

        it 'enables firewall' do
          expect(chef_run).to install_firewall('default')
        end

        [80, 443].each do |listen_port|
          it "runs resoruce firewall_rule to open port #{listen_port}" do
            expect(chef_run).to create_firewall_rule("apache listen port #{listen_port}").with(port: listen_port, protocol: :tcp)
          end
        end

        it 'installs mysql client' do
          expect(chef_run).to install_package('mysql-client')
        end
      end
    end
  end
end
