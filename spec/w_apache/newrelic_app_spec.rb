require_relative '../spec_helper'

describe 'w_apache::newrelic_app' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set['w_common']['web_apps'] = web_apps
      node.set['w_memcached']['ips'] = ['127.0.0.1']
      node.set['w_apache']['newrelic_app_enabled'] = true
    end.converge(described_recipe)
  end

  before do
    stub_data_bag_item("newrelic", "newrelic_license").and_return('newrelic_license_key' => 'xxxxxxxxxxxxxxxxxxxx')
  end
  
  it 'installs newrelic app monitoring' do
    expect(chef_run).to install_newrelic_agent_php('install').with(
        license: 'xxxxxxxxxxxxxxxxxxxx',
        app_name: 'PHP Application',
        config_file: '/etc/php5/mods-available/newrelic.ini',
        config_file_to_be_deleted: '/etc/php5/fpm/conf.d/newrelic.ini'
      )
  end
  
end
