node['w_common']['web_apps'].each do |web_app|

  next if web_app['vhost'].has_key?('create_docroot_dir') && web_app['vhost']['create_docroot_dir'] == false

  if web_app.has_key?('mysql') and web_app.has_key?('connection_domain') then

    if web_app['mysql'].instance_of?(Chef::Node::ImmutableArray) then
      databases = web_app['mysql']
    else
      databases = []
      databases << web_app['mysql']
    end

    template  web_app['vhost']['docroot'] + '/config_test.php' do
      source 'config_test.php.erb'
      variables(
        :db_domain => "0#{web_app['connection_domain']['db_domain']}",
        :databases => databases
      )
    end
  end

  file web_app['vhost']['docroot'] + '/info.php' do
    content '<?php phpinfo(); ?>'
  end

  redirect_dir = web_app['vhost']['docroot'] + '/redirect_test'
  directory redirect_dir
  %w[ old new ].each do |filename|
    file redirect_dir + "/#{filename}file.html" do
      content "<html><body>this is #{filename} file</body></html>"
    end
  end

  access_file_content = <<-eos
    RewriteEngine ON
    RewriteRule ^/redirect_test/oldfile.html$ /redirect_test/newfile.html [END,R=301]
  eos
  file redirect_dir + "/#{node['apache']['access_file_name']}" do
    content access_file_content
  end
end
