#
# Cookbook Name:: w_apache
# Recipe:: phalcon
#
# Copyright 2016 Joel Handwell
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

minor_version = node['php']['version'].split('.').first(2).join('.')

zephir_installed = 'test -e /usr/local/bin/zephir'

include_recipe 'build-essential' do
  not_if zephir_installed
end

include_recipe 'git' do
  not_if zephir_installed
end

%w(re2c libpcre3-dev).each do |dependency|
  package dependency do
    not_if zephir_installed
  end
end

git '/opt/zephir' do
  repository 'https://github.com/phalcon/zephir'
  not_if zephir_installed
  only_if { minor_version.to_f >= 7 }
end

execute './install -c' do
  cwd '/opt/zephir'
  not_if zephir_installed
  only_if { minor_version.to_f >= 7 }
end

phalcon_version = minor_version.to_f >= 7 ? '2.1.x' : 'phalcon-v2.0.13'

git '/opt/phalcon' do
  repository 'https://github.com/phalcon/cphalcon.git'
  revision phalcon_version
end

disabled_functions = node['php']['secure_functions']['disable_functions']
php_cli_ini = "#{node['php']['cli_conf_dir']}/php.ini"

ruby_block 'Temporary enables shell_exec for to successfuly build phalcon' do
  block do
    php_ini = Chef::Util::FileEdit.new(php_cli_ini)
    php_ini.search_file_replace_line(/disable_functions.*shell_exec.*/, "disable_functions = #{disabled_functions.sub(',shell_exec,', ',')}")
    php_ini.write_file
  end
  only_if { node['php']['secure_functions']['disable_functions'].include? 'shell_exec' }
end

execute './install' do
  cwd '/opt/phalcon/build'
  only_if { minor_version.to_f <= 5.6 }
end

execute 'zephir build -backend=ZendEngine3' do
  cwd '/opt/phalcon'
  only_if { minor_version.to_f >= 7 }
end

ruby_block 'Disable temporary enabled shell_exec' do
  block do
    php_ini = Chef::Util::FileEdit.new(php_cli_ini)
    php_ini.search_file_replace_line(/disable_functions/, "disable_functions = #{disabled_functions}")
    php_ini.write_file
  end
  only_if { node['php']['secure_functions']['disable_functions'].include? 'shell_exec' }
end

phalcon_ini = <<-EOT
; configuration for php gd module
; priority=20
extension=phalcon.so
EOT

phlcon_ini_path = "/etc/php/#{minor_version}/mods-available/phalcon.ini"

file phlcon_ini_path do
  content phalcon_ini
end

service node['php']['fpm_service']

%w(fpm cli).each do |php_execution_type|

  link "/etc/php/#{minor_version}/#{php_execution_type}/conf.d/20-phalcon.ini" do
    to phlcon_ini_path
    notifies :restart, "service[#{node['php']['fpm_service']}]"
  end
end
