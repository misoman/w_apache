# -*- mode: ruby -*-
# vi: set ft=ruby :
source 'https://supermarket.chef.io'

cookbook 'ubuntu'
cookbook 'apt'
cookbook 'apt-repo', git: 'https://github.com/sometimesfood/chef-apt-repo.git'
cookbook 'git'
cookbook 'monit', git: 'https://github.com/phlipper/chef-monit.git'
cookbook 'firewall', '~> 2.0.2'
cookbook 'ntp'
cookbook 'sudo'
cookbook 'timezone-ii'

cookbook 'apache2', '~> 3.1.0'
cookbook 'php', git: 'https://github.com/joelhandwell/chef-php.git'
cookbook 'php-fpm', git: 'https://github.com/yevgenko/cookbook-php-fpm.git'
cookbook 'xdebug', git: 'https://github.com/joelhandwell/xdebug.git'
cookbook 'phpmyadmin', git: 'https://github.com/priestjim/chef-phpmyadmin.git', ref: '0a8cef411aaa79420576f62a25f1e53a2e1b6e06'

cookbook 'nfs'
cookbook 'cron'
cookbook 'haproxy', git: 'https://github.com/fulloflilies/haproxy.git', ref: '90d25e2e07d549a3671417b2d347955d358e7e23'

group :wrapper do
  cookbook 'w_apache', path: './'
  cookbook 'w_nfs', git: 'https://github.com/haapp/w_nfs.git'
end

