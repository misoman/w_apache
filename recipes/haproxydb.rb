include_recipe	'haproxy::manual'

firewall 'default'

[node['haproxy']['admin']['port']].each do |haproxy_port|
  firewall_rule "listen port #{haproxy_port}" do
    port     haproxy_port
    protocol :tcp
  end
end
