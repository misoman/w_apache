require_relative '../spec_helper'

describe 'w_apache::vhosts' do
  context 'with default setting' do

    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.normal['w_common']['web_apps'] = web_apps
      end.converge(described_recipe)
    end

    before do
      stub_command("/usr/sbin/apache2 -t").and_return(true)
    end

    web_apps.each do |web_app|
      vhost = web_app[:vhost]
      next if vhost[:main_domain] == 'docroot-create-disable.com'

      it 'creates document root directory' do
        expect(chef_run).to create_directory("document root for #{vhost[:main_domain]}").with(path: vhost[:docroot], owner: 'www-data', group: 'www-data', recursive: true)
      end
    end

    it 'does not creates document root directory when specified' do
      expect(chef_run).not_to create_directory('document root for docroot-create-disable.com').with(path: '/websites/dcd', owner: 'www-data', group: 'www-data', recursive: true)
    end

    describe '/etc/apache2/sites-available/example.com.conf' do
      it 'is created' do
        expect(chef_run).to create_template('/etc/apache2/sites-available/example.com.conf')
      end

      it 'has default port' do
        expect(chef_run).to render_file('/etc/apache2/sites-available/example.com.conf').with_content(/VirtualHost \*:80/)
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

      it 'sets the default log level' do
        expect(chef_run).to render_file('/etc/apache2/sites-available/example.com.conf').with_content('LogLevel error')
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
        expect(chef_run).to render_file('/etc/apache2/sites-available/example2.com.conf').with_content('DirectoryIndex index.html index.htm index.php')
      end

      it 'overwrites the Log setting' do
        expect(chef_run).to render_file('/etc/apache2/sites-available/example2.com.conf').with_content('AllowOverride All')
      end

      it 'sets the default log level' do
        expect(chef_run).to render_file('/etc/apache2/sites-available/example2.com.conf').with_content('LogLevel info')
      end
    end

    describe '/etc/apache2/sites-available/custom-template-vhost.com.conf' do
      it 'is created' do
        expect(chef_run).to create_template('/etc/apache2/sites-available/custom-template-vhost.com.conf')
      end
    end
  end

  context 'with custom server port' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.normal['w_common']['web_apps'] = web_apps
        node.normal['apache']['listen'] = ['*:8888', '*:8433']
      end.converge(described_recipe)
    end

    before do
      stub_command("/usr/sbin/apache2 -t").and_return(true)
    end

    describe '/etc/apache2/sites-available/example.com.conf' do
      it 'has custom port' do
        expect(chef_run).to render_file('/etc/apache2/sites-available/example.com.conf').with_content(/VirtualHost \*:8888/)
      end
    end
  end
end
