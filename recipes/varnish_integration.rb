#
# Cookbook Name:: w_apache
# Recipe:: varnish_integration
#
# Copyright 2014, Joel Handwell
#
# license apachev2
#
#

file 'Varnish healthcheck script generated at default site document root' do
  path "#{node['apache']['docroot_dir']}/ping.php"
  content '<html><body>website is healthy</body></html>'
end

node['w_common']['web_apps'].each do |web_app|

  next unless web_app.has_key?('varnish')
  next unless web_app['varnish'].has_key?('purge_target')
  next unless web_app['varnish']['purge_target']

  Chef::Log.info "Generating hosts file entries for varnish purge target domains for #{web_app['connection_domain']['varnish_domain']}"

  node['w_varnish']['node_ipaddress_list'].each_with_index do |varnish_node_ip, index|
    domain = "#{index}#{web_app['connection_domain']['varnish_domain']}"
    hostsfile_entry "#{varnish_node_ip} #{domain} for #{web_app['vhost']['main_domain']}" do
      ip_address varnish_node_ip
      hostname domain
      action :append
      unique true
    end
  end
end
