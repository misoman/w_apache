require_relative '../spec_helper'

describe 'w_apache::blackfire' do

  php_versions.each do |version|

    minor_version = version[:minor]

    context "install php #{minor_version} from package" do

      let(:chef_run) do
        ChefSpec::SoloRunner.new do |node|
          node.normal['w_common']['web_apps'] = web_apps
          node.normal['w_apache']['blackfire_enabled'] = true
          node.normal['php']['version'] = version[:full]
        end.converge(described_recipe)
      end

      before do
        stub_data_bag_item("blackfire", "blackfire_credential").and_return('server_id' => 'test_serverid', 'server_token' => 'test_server_token')
      end

      it 'runs blackfire recipe' do
        expect(chef_run).to include_recipe('blackfire::default')
      end

      it 'installs blackfire php package' do
        expect(chef_run).to install_package('blackfire-php')
      end

      %W( /etc/php/#{minor_version}/mods-available/blackfire.ini /etc/blackfire/agent ).each do |file|
        it file do
         expect(chef_run).to render_file(file).with_content('test_serverid')
        end
      end

      it 'enables blackfire php config' do
        expect(chef_run).to run_execute('phpenmod blackfire')
      end
    end
  end
end
