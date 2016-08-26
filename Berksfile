# -*- mode: ruby -*-
# vi: set ft=ruby :
source 'https://supermarket.chef.io'

metadata

cookbook 'apache2', git: 'https://github.com/joelhandwell/chef-apache2', branch: 'loglevel'
cookbook 'php', '~> 1.8.0'
cookbook 'xdebug', git: 'https://github.com/joelhandwell/xdebug.git', ref: 'c336a7b4abbc5cf66bf68e29c7d293d584e001a6'
cookbook 'phpmyadmin', git: 'https://github.com/priestjim/chef-phpmyadmin.git', ref: 'dbc38b6878b60e159679a438acf08e1adfa019b6'
cookbook 'newrelic', '~> 2.18.0'
cookbook 'w_nfs', git: 'https://github.com/haapp/w_nfs.git'
cookbook 'haproxy', git: 'https://github.com/hw-cookbooks/haproxy.git', ref: 'a42d14ee291a95b68f79b50e46bcd6eefdb25a35'

group :chefspec do
  cookbook 'custom_tmpl_cookbook', path: 'test/fixtures/cookbooks/custom_tmpl_cookbook'
end

group :w_common do
  cookbook 'ubuntu'
  cookbook 'apt-repo', git: 'https://github.com/sometimesfood/chef-apt-repo.git'
  cookbook 'git'
  cookbook 'monit', git: 'https://github.com/phlipper/chef-monit.git'
  cookbook 'ntp'
  cookbook 'sudo'
  cookbook 'timezone-ii'
  cookbook 'w_common', git: 'https://github.com/haapp/w_common.git'
end
