node['w_common']['web_apps'].each do |web_app|

  vhost = web_app['vhost']

  directory "document root for #{vhost['main_domain']}" do
    path vhost['docroot']
    owner node['w_apache']['owner']
    group node['w_apache']['group']
    recursive true
    not_if { vhost.has_key?('create_docroot_dir') && vhost['create_docroot_dir'] == false }
  end

  web_app vhost['main_domain'] do
    server_name vhost['main_domain']
    server_port node['apache']['listen'].first.split(':').last
    server_aliases vhost['aliases']
    docroot vhost['docroot']
    cookbook vhost.has_key?('tpl_cookbook') ? vhost['tpl_cookbook'] : 'w_apache'
    template vhost.has_key?('tpl_source') ? vhost['tpl_source'] : 'w_apache_web_app.conf.erb'
    allow_override 'All'
    directory_index ["index.html", "index.htm", "index.php"]
    log_level vhost.has_key?('log_level') ? vhost['log_level'] : 'error'
    redirect_http_to_https vhost.has_key?('redirect_http_to_https') ? vhost['redirect_http_to_https'] : false
  end
end
