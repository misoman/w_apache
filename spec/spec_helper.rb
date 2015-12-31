require 'chefspec'
require 'chefspec/berkshelf'
require 'mymatchers'

ChefSpec::Coverage.start! do
  add_filter(%r{apt})
  add_filter(%r{apache2})
  add_filter(%r{php})
  add_filter(%r{phpmyadmin})
  add_filter(%r{xdebug})
  add_filter(%r{monit})
  add_filter(%r{build-essential})
  add_filter(%r{git})
  add_filter(%r{apt-repo})
  add_filter(%r{nfs})
  add_filter(%r{haproxy})
end

RSpec.configure do |config|
  config.platform = 'ubuntu'
  config.version = '14.04'
end

def web_apps
    [
      { vhost: { main_domain: 'example.com', aliases: ['www.example.com', 'ex.com'], docroot: '/websites/example.com/www'  },  mysql: [ { db: 'db',                  user: 'user', password: 'password' }] , deploy: { repo_ip: '9.9.9.9', repo_domain: 'git.examplewebsite.com', repo_path: '/websites/example.com', repo_url: 'https://git.examplewebsite.com/www.git' }   , connection_domain: { webapp_domain: 'webapp.example.com', db_domain: 'db.example.com', varnish_domain: 'varnish.example.com' }, varnish: { purge_target: true }  },
      { vhost: { main_domain: 'example2.com',                                        docroot: '/websites/example2.com/sub' },  mysql: [ { db: ['db2', 'db3', 'db4'], user: 'user', password: 'password' }] , deploy: { repo_ip: '9.9.9.9', repo_domain: 'git.examplewebsite.com', repo_path: '/websites/example2.com', repo_url: 'https://git.examplewebsite.com/www2.git' } , connection_domain: { webapp_domain: 'webapp.example.com', db_domain: 'db.example.com'                                        }                                   },
      { vhost: { main_domain: 'example3.com',                                        docroot: '/websites/example3.com/sub' },  mysql: [ { db: ['db2', 'db3', 'db4'], user: 'user', password: 'password' }]                                                                                                                                                                   , connection_domain: { webapp_domain: 'webapp.example.com', db_domain: 'db.example.com'                                        }                                   },
      { vhost: { main_domain: 'docroot-only-vhost.com',                              docroot: '/websites/dov'              }}
    ]
end
