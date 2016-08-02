#
# Cookbook Name:: w_apache
# Spec:: default
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


require_relative '../spec_helper'

describe 'w_apache::phalcon' do

phalcon_ini = <<-EOT
; configuration for php gd module
; priority=20
extension=phalcon.so
EOT

  php_versions.each do |version|

    minor_version = version[:minor]
    phalcon_version = minor_version.to_f >= 7 ? '2.1.x' : 'phalcon-v2.0.13'

    context "install phalcon for php #{minor_version}" do

      before do
        stub_command('test -e /usr/local/bin/zephir').and_return(false)
      end

      let(:chef_run) do
        ChefSpec::SoloRunner.new do |node|
          node.override['w_common']['web_apps'] = web_apps
          node.override['php']['version'] = version[:full]
        end.converge(described_recipe)
      end

      it 'install dependencies via cookbooks' do
        expect(chef_run).to include_recipe('build-essential')
        expect(chef_run).to include_recipe('git')
      end

      %w(re2c libpcre3-dev).each do |name|
        it "install dependent package #{name}" do
          expect(chef_run).to install_package(name)
        end
      end

      it 'installs dependency to build phalcon' do
        expect(chef_run).to sync_git('/opt/phalcon').with(repository: 'https://github.com/phalcon/cphalcon.git', revision: phalcon_version)
      end

      it 'temporary enables shell_exec php function to build phalcon' do
        expect(chef_run).to run_ruby_block('Temporary enables shell_exec for to successfuly build phalcon')
      end

      if minor_version.to_f <= 5.6 then
        it 'runs phalcon install script for php 5' do
          expect(chef_run).to run_execute('./install').with(cwd: '/opt/phalcon/build')
        end
      end

      if minor_version.to_f >= 7 then

        it 'clones zephir' do
          expect(chef_run).to sync_git('/opt/zephir').with(repository: 'https://github.com/phalcon/zephir')
        end

        it 'runs zephir install script' do
          expect(chef_run).to run_execute('./install -c').with(cwd: '/opt/zephir')
        end

        it 'runs phalcon install script for php 7' do
          expect(chef_run).to run_execute('zephir build -backend=ZendEngine3').with(cwd: '/opt/phalcon')
        end
      end

      it 'disable temporary enabled shell_exec' do
        expect(chef_run).to run_ruby_block('Disable temporary enabled shell_exec')
      end

      it 'create phalcon php module config file' do
        expect(chef_run).to create_file("/etc/php/#{minor_version}/mods-available/phalcon.ini").with(content: phalcon_ini)
      end

      it 'declares fpm service for restart notification' do
        fpm_service = chef_run.service("php#{minor_version}-fpm")
        expect(fpm_service).to do_nothing
      end

      %w(fpm cli).each do |php_execution_type|
        it 'enable phalcon' do
          expect(chef_run).to create_link("/etc/php/#{minor_version}/#{php_execution_type}/conf.d/20-phalcon.ini").with(to: "/etc/php/#{minor_version}/mods-available/phalcon.ini")
        end
      end
    end
  end
end
