execute 'pkill -u phpmyadmin' do
  only_if 'lsof -u phpmyadmin | grep phpmyadmin'
end

include_recipe 'phpmyadmin'

apache_conf 'phpmyadmin' do
  cookbook 'w_apache'
end

phpmyadmin = data_bag_item('w_apache','phpmyadmin')

execute 'htpasswd_create' do
  command "htpasswd -cbm #{node['phpmyadmin']['home']}/.htpasswd #{phpmyadmin['user']} #{phpmyadmin['passwd']}"
end
