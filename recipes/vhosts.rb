directory '/websites' do
  owner 'www-data'
  group 'www-data'
  not_if 'ls /websites'
end

node['w_common']['web_apps'].each do |web_app|

  vhost = web_app['vhost']
  dir = vhost['docroot'] ? vhost['docroot'] : vhost['main_domain']
  document_root = '/websites/' + dir
  directory document_root do
    owner 'www-data'
    group 'www-data'
    recursive true
  end

  web_app vhost['main_domain'] do
    server_name vhost['main_domain']
    server_aliases vhost['aliases']
    docroot document_root
    cookbook 'apache2'
    allow_override 'All'
    directory_index ["index.html", "index.htm", "index.php"]
  end

  if node['w_apache']['nfs']['enabled'] then
    data_link = document_root + '/' + node['w_apache']['nfs']['data_dir_name']
    data_dir =  node['nfs']['directory'] + node['nfs']['subtree'] + '/websites/' + dir + '/' + node['w_apache']['nfs']['data_dir_name']

    directory data_dir do
      owner 'www-data'
      group 'www-data'
      recursive true
    end

    link data_link do
      to data_dir
      owner 'www-data'
      group 'www-data'
    end
  end
end
