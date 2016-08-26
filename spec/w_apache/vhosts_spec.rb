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
      domain = vhost[:main_domain]
      docroot = vhost[:docroot]

      if domain == 'docroot-create-disable.com' then
        it 'does not creates document root directory when specified' do
          expect(chef_run).not_to create_directory('document root for docroot-create-disable.com').with(path: '/websites/dcd', owner: 'www-data', group: 'www-data', recursive: true)
        end
      else
        it 'creates document root directory' do
          expect(chef_run).to create_directory("document root for #{domain}").with(path: docroot, owner: 'www-data', group: 'www-data', recursive: true)
        end
      end

      describe '/etc/apache2/sites-available/example.com.conf' do
        it 'is created' do
          expect(chef_run).to create_template("/etc/apache2/sites-available/#{domain}.conf")
        end

        it 'renders vhost conf file as expected' do
          expect(chef_run).to render_file("/etc/apache2/sites-available/#{domain}.conf").with_content { |content|
            expect(content).to match(/VirtualHost \*:80/)
            expect(content).to match(/ServerName #{domain}/)
            expect(content).to match(/DocumentRoot #{docroot}/)

            if domain == 'example.com' then
              expect(content).to match(/ServerAlias #{vhost[:aliases].join(' ')}/)
            end

            expect(content).to match(/DirectoryIndex index.html index.htm index.php/)
            expect(content).to match(/AllowOverride All/)

            if domain == 'example2.com' then
              expect(content).to match(/LogLevel info/)
            else
              expect(content).to match(/LogLevel error/)
            end

            if domain == 'ssl-only.example.com' then
              expect(content).to match(/#{Regexp.escape('RewriteRule ^/(.*)$        https://')}#{domain}#{Regexp.escape('/$1 [L,R=301]')}/)
            else
              expect(content).to match(/#{Regexp.escape('RewriteRule ^/(.*)$        http://')}#{domain}#{Regexp.escape('/$1 [L,R=301]')}/)
            end

            if domain == 'custom-template-vhost.com' then
              expect(content).to match(/this apache vhost conf file is generated by custom_vhost_template.erb of custom_tmpl_cookbook/)
            end
          }
        end
      end
    end

    describe '/etc/apache2/sites-available/custom-template-vhost.com.conf' do
      it 'is created' do
        expect(chef_run).to create_template('/etc/apache2/sites-available/custom-template-vhost.com.conf').with(source: 'custom_vhost_template.erb', cookbook: 'custom_tmpl_cookbook')
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
