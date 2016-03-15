require 'rspec'
require 'serverspec'

set :backend, :exec

def php_minor_version
  File.read('/var/php_version_intended_to_be_installed_by_chef').strip
end
