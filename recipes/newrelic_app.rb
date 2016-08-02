minor_version = node['php']['version'].split('.').first(2).join('.')

newrelic_agent_php 'install' do
  license data_bag_item('newrelic', 'newrelic_license')['newrelic_license_key']
  app_name node['w_apache']['newrelic']['app_name']
  config_file "/etc/php/#{minor_version}/mods-available/newrelic.ini"
  config_file_to_be_deleted "/etc/php/#{minor_version}/fpm/conf.d/newrelic.ini"
end

file "/etc/php/#{minor_version}/cli/conf.d/newrelic.ini" do
  action :delete
end
