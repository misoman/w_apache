node['w_common']['web_apps'].each do |web_app|

  vhost = web_app['vhost']

  directory vhost['docroot'] do
    owner 'www-data'
    group 'www-data'
    recursive true
  end

  web_app vhost['main_domain'] do
    server_name vhost['main_domain']
    server_aliases vhost['aliases']
    docroot vhost['docroot']
    cookbook 'apache2'
    allow_override 'All'
    directory_index ["index.html", "index.htm", "index.php"]
  end

# commented until this is resolved
#  if node['w_apache']['nfs']['enabled'] then
#    data_link = document_root + '/' + node['w_apache']['nfs']['data_dir_name']
#    data_dir =  node['nfs']['directory'] + node['nfs']['subtree'] + '/websites/' + dir + '/' + node['w_apache']['nfs']['data_dir_name']
#
#    directory data_dir do
#      owner 'www-data'
#      group 'www-data'
#      recursive true
#    end
#
#    link data_link do
#      to data_dir
#      owner 'www-data'
#      group 'www-data'
#    end
#  end
end
