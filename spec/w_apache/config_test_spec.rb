require_relative '../spec_helper'

describe 'w_apache::config_test' do
  context 'with default setting' do

    let(:web_apps) do
      [
        { vhost: { main_domain: 'example.com', aliases: ['www.example.com', 'ex.com'], docroot: '/websites/example.com/www'  },  mysql: [ { db: 'db',                  user: 'user', password: 'password' }] , deploy: { repo_ip: '9.9.9.9', repo_domain: 'git.examplewebsite.com', repo_path: '/websites/example.com', repo_url: 'https://git.examplewebsite.com/www.git' }   , connection_domain: { webapp_domain: 'webapp.example.com', db_domain: 'db.example.com', varnish_domain: 'varnish.example.com' }, varnish: { purge_target: true }  },
        { vhost: { main_domain: 'example2.com',                                        docroot: '/websites/example2.com/sub' },  mysql: [ { db: ['db2', 'db3', 'db4'], user: 'user', password: 'password' }] , deploy: { repo_ip: '9.9.9.9', repo_domain: 'git.examplewebsite.com', repo_path: '/websites/example2.com', repo_url: 'https://git.examplewebsite.com/www2.git' } , connection_domain: { webapp_domain: 'webapp.example.com', db_domain: 'db.example.com'                                        }                                   },
        { vhost: { main_domain: 'example3.com',                                        docroot: '/websites/example3.com/sub' },  mysql: [ { db: ['db2', 'db3', 'db4'], user: 'user', password: 'password' }]                                                                                                                                                                   , connection_domain: { webapp_domain: 'webapp.example.com', db_domain: 'db.example.com'                                        }                                   },
        { vhost: { main_domain: 'docroot-only-vhost.com',                              docroot: '/websites/dov'              }}
      ]
    end

    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['w_common']['web_apps'] = web_apps
        node.set['w_memcached']['ips'] = ['127.0.0.1']
        node.set['apache']['access_file_name'] = '.htaccess'
      end.converge(described_recipe)
    end

    it 'creates config_test.php' do
      expect(chef_run).to create_template('/websites/example.com/www/config_test.php')
      expect(chef_run).to create_template('/websites/example2.com/sub/config_test.php')
      expect(chef_run).to create_template('/websites/example3.com/sub/config_test.php')
      expect(chef_run).not_to create_template('/websites/dov/config_test.php')
    end

    it 'creates info.php' do
      expect(chef_run).to create_file('/websites/example.com/www/info.php').with_content('<?php phpinfo(); ?>')
      expect(chef_run).to create_file('/websites/example2.com/sub/info.php').with_content('<?php phpinfo(); ?>')
      expect(chef_run).to create_file('/websites/example3.com/sub/info.php').with_content('<?php phpinfo(); ?>')
      expect(chef_run).to create_file('/websites/dov/info.php').with_content('<?php phpinfo(); ?>')
    end

    it 'prepares redirect test' do
      expect(chef_run).to create_directory('/websites/example.com/www/redirect_test')
      expect(chef_run).to create_directory('/websites/example2.com/sub/redirect_test')
      expect(chef_run).to create_directory('/websites/example3.com/sub/redirect_test')
      expect(chef_run).to create_directory('/websites/dov/redirect_test')
    end

    %w[ old new ].each do |filename|
      it "creates /websites/example.com/www/redirect_test/#{filename}file.html" do
        expect(chef_run).to create_file("/websites/example.com/www/redirect_test/#{filename}file.html").with_content("<html><body>this is #{filename} file</body></html>")
        expect(chef_run).to create_file("/websites/example2.com/sub/redirect_test/#{filename}file.html").with_content("<html><body>this is #{filename} file</body></html>")
        expect(chef_run).to create_file("/websites/example3.com/sub/redirect_test/#{filename}file.html").with_content("<html><body>this is #{filename} file</body></html>")
        expect(chef_run).to create_file("/websites/dov/redirect_test/#{filename}file.html").with_content("<html><body>this is #{filename} file</body></html>")
      end
    end

    access_file_content = <<-eos
    RewriteEngine ON\n    Redirect 301 /redierct_test/oldfile.html /redierct_test/newfile.html
  eos

    it 'creates file /websites/example.com/www/redirect_test/.htaccess' do
      expect(chef_run).to create_file('/websites/example.com/www/redirect_test/.htaccess').with_content(access_file_content)
      expect(chef_run).to create_file('/websites/example2.com/sub/redirect_test/.htaccess').with_content(access_file_content)
      expect(chef_run).to create_file('/websites/example3.com/sub/redirect_test/.htaccess').with_content(access_file_content)
      expect(chef_run).to create_file('/websites/dov/redirect_test/.htaccess').with_content(access_file_content)
    end
  end
end
