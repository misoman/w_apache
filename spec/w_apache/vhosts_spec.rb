require_relative '../spec_helper'

describe 'w_apache::vhosts' do
  context 'with default setting' do

    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['w_common']['web_apps'] = web_apps
        node.set['w_memcached']['ips'] = ['127.0.0.1']
      end.converge(described_recipe)
    end

    before do
      stub_command("/usr/sbin/apache2 -t").and_return(true)
    end

    it 'creates document root directory' do
      expect(chef_run).to create_directory('document root for example.com'                      ).with(path: '/websites/example.com/www'         , owner: 'www-data', group: 'www-data', recursive: true)
      expect(chef_run).to create_directory('document root for example2.com'                     ).with(path: '/websites/example2.com/sub'        , owner: 'www-data', group: 'www-data', recursive: true)
      expect(chef_run).to create_directory('document root for example3.com'                     ).with(path: '/websites/example3.com/sub'        , owner: 'www-data', group: 'www-data', recursive: true)
      expect(chef_run).to create_directory('document root for docroot-only-vhost.com'           ).with(path: '/websites/dov'                     , owner: 'www-data', group: 'www-data', recursive: true)
      expect(chef_run).not_to create_directory('document root for docroot-create-disable.com'   ).with(path: '/websites/dcd'                     , owner: 'www-data', group: 'www-data', recursive: true)
      expect(chef_run).to create_directory('document root for multi-repo-vhost.com'             ).with(path: '/websites/multi-repo-vhost'        , owner: 'www-data', group: 'www-data', recursive: true)
      expect(chef_run).to create_directory('document root for ssl.example.com'                  ).with(path: '/websites/example.com/ssl'         , owner: 'www-data', group: 'www-data', recursive: true)
      expect(chef_run).to create_directory('document root for ssl-disabled.example.com'         ).with(path: '/websites/example.com/ssl_disabled', owner: 'www-data', group: 'www-data', recursive: true)
      expect(chef_run).to create_directory('document root for ssl-without-intermediate-cert.com').with(path: '/websites/ssl-website-wic.com'     , owner: 'www-data', group: 'www-data', recursive: true)
    end

    it 'creates directory /websites/example2.com/sub' do
    end

    describe '/etc/apache2/sites-available/example.com.conf' do
      it 'is created' do
        expect(chef_run).to create_template('/etc/apache2/sites-available/example.com.conf')
      end

      it 'has vhost example.com' do
        expect(chef_run).to render_file('/etc/apache2/sites-available/example.com.conf').with_content('ServerName example.com')
      end

      it 'has doc root /websites/example.com/www' do
        expect(chef_run).to render_file('/etc/apache2/sites-available/example.com.conf').with_content('DocumentRoot /websites/example.com/www')
      end

      it 'has serveraliases www.example.com and ex.com' do
        expect(chef_run).to render_file('/etc/apache2/sites-available/example.com.conf').with_content('ServerAlias www.example.com ex.com')
      end

      it 'has directory index index.html index.htm index.php' do
        expect(chef_run).to render_file('/etc/apache2/sites-available/example.com.conf').with_content('DirectoryIndex index.html index.htm index.php')
      end

      it 'overwrites the Log setting' do
        expect(chef_run).to render_file('/etc/apache2/sites-available/example.com.conf').with_content('AllowOverride All')
      end
    end

    describe '/etc/apache2/sites-available/example2.com.conf' do
      it 'is created' do
        expect(chef_run).to create_template('/etc/apache2/sites-available/example2.com.conf')
      end

      it 'has vhost example2.com' do
        expect(chef_run).to render_file('/etc/apache2/sites-available/example2.com.conf').with_content('ServerName example2.com')
      end

      it 'has doc root /websites/example2.com/sub' do
        expect(chef_run).to render_file('/etc/apache2/sites-available/example2.com.conf').with_content('DocumentRoot /websites/example2.com/sub')
      end

      it 'has directory index index.html index.htm index.php' do
        expect(chef_run).to render_file('/etc/apache2/sites-available/example.com.conf').with_content('DirectoryIndex index.html index.htm index.php')
      end

      it 'overwrites the Log setting' do
        expect(chef_run).to render_file('/etc/apache2/sites-available/example.com.conf').with_content('AllowOverride All')
      end
    end
  end
end
