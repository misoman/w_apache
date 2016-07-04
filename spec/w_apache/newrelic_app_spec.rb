require_relative '../spec_helper'

describe 'w_apache::newrelic_app' do

  php_versions.each do |version|

    minor_version = version[:minor]

    context "install php #{minor_version} from package" do

      let(:chef_run) do
        ChefSpec::SoloRunner.new do |node|
          node.set['w_common']['web_apps'] = web_apps
          node.set['w_apache']['newrelic_app_enabled'] = true
          node.set['php']['version'] = version[:full]
        end.converge(described_recipe)
      end

      before do
        stub_data_bag_item("newrelic", "newrelic_license").and_return('newrelic_license_key' => 'xxxxxxxxxxxxxxxxxxxx')
      end

      it 'installs newrelic app monitoring' do
        expect(chef_run).to install_newrelic_agent_php('install').with(
            license: 'xxxxxxxxxxxxxxxxxxxx',
            app_name: 'PHP Application',
            config_file: "/etc/php/#{minor_version}/mods-available/newrelic.ini",
            config_file_to_be_deleted: "/etc/php/#{minor_version}/fpm/conf.d/newrelic.ini"
          )
      end
    end
  end
end
