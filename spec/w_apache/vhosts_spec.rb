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
      expect(chef_run).to create_directory('/websites/example.com/www').with(owner: 'www-data', group: 'www-data', recursive: true)
      expect(chef_run).to create_directory('/websites/example2.com/sub').with(owner: 'www-data', group: 'www-data', recursive: true)
      expect(chef_run).to create_directory('/websites/example3.com/sub').with(owner: 'www-data', group: 'www-data', recursive: true)
      expect(chef_run).to create_directory('/websites/dov').with(owner: 'www-data', group: 'www-data', recursive: true)
      expect(chef_run).to create_directory('/websites/example.com/ssl_disabled').with(owner: 'www-data', group: 'www-data', recursive: true)
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
