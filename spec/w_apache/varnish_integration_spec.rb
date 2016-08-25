require_relative '../spec_helper'

describe 'w_apache::varnish_integration' do
  context 'with default setting' do

    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.normal['w_common']['web_apps'] = web_apps
        node.normal['w_varnish']['node_ipaddress_list'] = ['7.7.7.7', '8.8.8.8']
      end.converge(described_recipe)
    end

    it 'creates Varnish healthcheck script generated at default site document root' do
      expect(chef_run).to create_file('/var/www/html/ping.php').with_content('<html><body>website is healthy</body></html>')
    end

    it 'generates /etc/hosts file entries to enable communication btw web and varnish server' do
      expect(chef_run).to append_hostsfile_entry('7.7.7.7 0varnish.example.com for example.com').with(ip_address: '7.7.7.7', hostname: '0varnish.example.com', unique: true)
      expect(chef_run).to append_hostsfile_entry('8.8.8.8 1varnish.example.com for example.com').with(ip_address: '8.8.8.8', hostname: '1varnish.example.com', unique: true)
    end
  end
end
