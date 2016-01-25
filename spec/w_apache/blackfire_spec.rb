require_relative '../spec_helper'

describe 'w_apache::blackfire' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set['w_common']['web_apps'] = web_apps
      node.set['w_memcached']['ips'] = ['127.0.0.1']
      node.set['w_apache']['blackfire_enabled'] = true
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

  %w( /etc/php5/fpm/conf.d/blackfire.ini /etc/blackfire/agent ).each do |file|
    it file do
     expect(chef_run).to render_file(file).with_content('test_serverid')
    end
  end
  
end
