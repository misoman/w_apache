require_relative '../spec_helper'

describe 'w_apache::composer' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.normal['w_common']['web_apps'] = web_apps
      node.automatic['memory']['total'] = '4049656kB'
      node.automatic['memory']['swap']['total'] = '1024kB'
      node.normal['w_apache']['composer_enabled'] = true
    end.converge(described_recipe)
  end

  before do
    stub_command("php -m | grep 'Phar'").and_return(true)
  end

  it 'creates .cache directory' do
    #check existed .cache directory with user ownership
    expect(chef_run).to create_directory('/var/www/composer').with(
      user: 'www-data',
      group: 'www-data',
    )
  end

  it 'runs composer recipe' do
    expect(chef_run).to include_recipe('composer')
  end

  it 'creates remote file /usr/local/bin/composer' do
    expect(chef_run).to create_remote_file('/usr/local/bin/composer')
  end
end
