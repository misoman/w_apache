raise 'Blackfire and xdebug can not installed together, please set "w_apache": { "blackfire_enabled": false } in your role/environment file to install xdebug' if node['w_apache']['blackfire_enabled']

include_recipe 'xdebug'

firewall 'default'

firewall_rule 'xdebug' do
  port     9000
  protocol :tcp
end
