require_relative '../spec_helper'

describe 'w_apache::config_test' do
  context 'with default setting' do

    let(:access_file_content) do
      <<-eos
    RewriteEngine ON\n    RewriteRule ^/redirect_test/oldfile.html$ /redirect_test/newfile.html [END,R=301]
      eos
    end

    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.normal['w_common']['web_apps'] = web_apps
      end.converge(described_recipe)
    end

    web_apps.each do |web_app|
      vhost = web_app[:vhost]

      if vhost[:main_domain] =~ /^example.com|example2.com|example3.com/ then
        it 'creates config_test.php' do
          expect(chef_run).to create_template("#{vhost[:docroot]}/config_test.php")
        end
      end

      unless vhost[:main_domain] =~ /docroot-create-disable.com|checkout-repo-vhost.com/ then
        it 'creates info.php' do
          expect(chef_run).to create_file("#{vhost[:docroot]}/info.php").with_content('<?php phpinfo(); ?>')
        end

        it 'prepares redirect test' do
          expect(chef_run).to create_directory("#{vhost[:docroot]}/redirect_test")
        end

        %w[ old new ].each do |filename|
          it "creates #{vhost[:docroot]}/redirect_test/#{filename}file.html" do
            expect(chef_run).to create_file("#{vhost[:docroot]}/redirect_test/#{filename}file.html").with_content("<html><body>this is #{filename} file</body></html>")
          end
        end

        it "creates file #{vhost[:docroot]}/www/redirect_test/.htaccess" do
          expect(chef_run).to create_file("#{vhost[:docroot]}/redirect_test/.htaccess").with_content(access_file_content)
        end
      end
    end
  end
end
