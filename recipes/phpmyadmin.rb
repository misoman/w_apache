execute 'pkill -u phpmyadmin' do
  only_if 'lsof -u phpmyadmin | grep phpmyadmin'
end

include_recipe 'phpmyadmin'

apache_conf 'phpmyadmin' do
  cookbook 'w_apache'
end

package 'apache2-utils' #if platform_family?('debian', 'suse') && node['apache']['version'] == '2.4'

phpmyadmin = data_bag_item('w_apache','phpmyadmin')

execute 'htpasswd_create' do
  command "htpasswd -cbm #{node['phpmyadmin']['home']}/.htpasswd #{phpmyadmin['user']} #{phpmyadmin['passwd']}"
end
