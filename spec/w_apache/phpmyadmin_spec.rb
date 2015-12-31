require_relative '../spec_helper'

describe 'w_apache::phpmyadmin' do

  before do
    stub_command("lsof -u phpmyadmin | grep phpmyadmin").and_return(false)
    stub_command("/usr/sbin/apache2 -t").and_return(true)
    stub_data_bag_item("w_apache", "phpmyadmin").and_return('id' => 'phpmyadmin', 'user' => 'user', 'passwd' => 'passwd')
  end

  context 'in all environment' do

    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.automatic['memory']['total'] = '4049656kB'
        node.automatic['memory']['swap']['total'] = '1024kB'
        node.set['w_common']['web_apps'] = web_apps
        node.set['w_memcached']['ips'] = ['127.0.0.1']
      end.converge(described_recipe)
    end

    it 'does not kill process executed by user phpmyadmin' do
      expect(chef_run).to_not run_execute('pkill -u phpmyadmin')
    end

    it 'includes apache2::default recipe' do
      expect(chef_run).to include_recipe('apache2::default')
    end

    it 'create template phpmyadmin.conf' do
      expect(chef_run).to render_file('/etc/apache2/conf-available/phpmyadmin.conf')
    end

    it 'reloads apache after updating phpmyadmin.conf' do
      conf_template = chef_run.template('/etc/apache2/conf-available/phpmyadmin.conf')
      expect(conf_template).to notify('service[apache2]').to(:reload).delayed
    end

    it 'installs apache2-utils' do
      expect(chef_run).to install_package('apache2-utils')
    end

    it 'execute htpasswd_create' do
      expect(chef_run).to run_execute('htpasswd -cbm /websites/phpmyadmin/.htpasswd user passwd')
    end
  end
end
