require_relative '../spec_helper'

describe 'w_apache::composer' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set['w_common']['web_apps'] = web_apps
      node.set['w_memcached']['ips'] = ['127.0.0.1']
      node.automatic['memory']['total'] = '4049656kB'
      node.automatic['memory']['swap']['total'] = '1024kB'
      node.set['w_apache']['composer_enabled'] = true
    end.converge(described_recipe)
  end

  before do
    stub_command("php -m | grep 'Phar'").and_return(true)
  end

  it 'runs composer recipe' do
    expect(chef_run).to include_recipe('composer')
  end

  it 'creates remote file /usr/local/bin/composer' do
    expect(chef_run).to create_remote_file('/usr/local/bin/composer')
  end
end
