require_relative '../spec_helper'

describe 'w_apache::haproxydb' do

  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|   
  			node.set['w_common']['web_apps'] = [
          {"vhost" => {
                  "main_domain" => "example.com",
                  "aliases" => ['www.example.com', 'ex.com'],
                  "docroot" => "www"
                  },
           "deploy" => {
                  "repo_ip" => "9.9.9.9",
                  "repo_domain" => "git.examplewebsite.com",
                  "repo_url" => "https://git.examplewebsite.com/www.git"
           },
           "connection_domain" => {
                   "db_domain" => "db.example.com",
                   "webapp_domain" => "webapp.example.com",
                   "varnish_domain" => "varnish.example.com"
                  },
           "mysql" =>  [
                   {"db" => "dbname", "user" => "username", "password" => "password"},
                   {"db" => "dbname2", "user" => "username2", "password" => "password2"}
                   ]
          }
  			]
  			node.set['w_memcached']['ips'] = ['127.0.0.1']
      end.converge(described_recipe)
    end    

  it 'runs recipe haproxy::manual' do
    expect(chef_run).to include_recipe('haproxy::manual')
  end

  it 'enables firewall' do
  	expect(chef_run).to install_firewall('default')
  end

  [22002].each do |listen_port|
  	it "runs resoruce firewall_rule to open port #{listen_port}" do
    	expect(chef_run).to create_firewall_rule("listen port #{listen_port}").with(port: listen_port, protocol: :tcp)
    end
  end
        
end