require_relative '../spec_helper'

describe 'w_apache::monit' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set['w_apache']['haproxydb_enabled'] = true
      node.set['w_common']['web_apps'] = web_apps
    end.converge(described_recipe)
  end

  it 'includes recipe monit' do
    expect(chef_run).to include_recipe('monit')
  end

  it 'run resource monit_monitrc' do
    expect(chef_run).to add_monit_config('apache2')
  end

  it 'run resource monit_monitrc' do
    expect(chef_run).to add_monit_config('haproxy')
  end
end
