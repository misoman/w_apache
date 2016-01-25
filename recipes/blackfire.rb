if node['w_apache']['xdebug_enabled'] then
  raise 'black fire will not work with xdebug, please do not install xdebug or remove it if already installed'
end

blackfire = data_bag_item('blackfire', 'blackfire_credential')

node.set['blackfire']['agent']['server_id'] = blackfire['server_id']
node.set['blackfire']['agent']['server_token'] = blackfire['server_token']

node.set['blackfire']['php']['server_id'] = blackfire['server_id']
node.set['blackfire']['php']['server_token'] = blackfire['server_token']

include_recipe 'blackfire'