name             'w_apache'
maintainer       'Joel Handwell'
maintainer_email 'joelhandwell@gmail.com'
license          'apachev2'
description      'Installs/Configures apache2, php, php fpm and other related packages used in web server'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.1.11'
issues_url       'https://github.com/haapp/w_apache/issues'
source_url       'https://github.com/haapp/w_apache'

depends 'apt'
depends 'build-essential'
depends 'ubuntu'
depends 'hostsfile'
depends 'apache2'
depends 'php'
depends 'composer'
depends 'git'
depends 'firewall'
depends 'xdebug'
depends 'monit'
depends 'phpmyadmin'
depends 'w_nfs'
depends 'haproxy'
depends 'newrelic'
depends 'blackfire'
