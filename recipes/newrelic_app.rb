newrelic_agent_php 'install' do
  license data_bag_item('newrelic', 'newrelic_license')['newrelic_license_key']
  app_name node['w_apache']['newrelic']['app_name']
  config_file '/etc/php5/mods-available/newrelic.ini'
  config_file_to_be_deleted '/etc/php5/fpm/conf.d/newrelic.ini'
end