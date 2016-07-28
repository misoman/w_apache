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

cookbook 'apache2', git: 'https://github.com/joelhandwell/chef-apache2', branch: 'loglevel'
cookbook 'php', '~> 1.8.0'
cookbook 'composer'
cookbook 'php-phalcon', git: 'https://github.com/k-kinzal/chef-php-phalcon.git'
cookbook 'xdebug', git: 'https://github.com/joelhandwell/xdebug.git', ref: 'c336a7b4abbc5cf66bf68e29c7d293d584e001a6'
cookbook 'phpmyadmin', git: 'https://github.com/priestjim/chef-phpmyadmin.git', ref: 'dbc38b6878b60e159679a438acf08e1adfa019b6'
cookbook 'newrelic', '~> 2.18.0'

cookbook 'nfs'
cookbook 'cron', '~> 1.7.5'
cookbook 'haproxy', git: 'https://github.com/hw-cookbooks/haproxy.git', ref: 'a42d14ee291a95b68f79b50e46bcd6eefdb25a35'

group :wrapper do
  cookbook 'w_common', git: 'https://github.com/haapp/w_common.git'
  cookbook 'w_apache', path: './'
  cookbook 'w_nfs', git: 'https://github.com/haapp/w_nfs.git'
end
