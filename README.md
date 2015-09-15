w_apache Cookbook
==================

[![Build Status](https://travis-ci.org/haapp/w_apache.svg?branch=master)](https://travis-ci.org/haapp/w_apache)

Chef cookbook to instal and configure apache2 and php-fpm. Expecting high availability architecture setting Varnish or HAProxy in front, Percona XtraDB Cluster in back load balanced by HAProxy which is installed in the same virtual machine as apache. Optinaly adds NFS for sharing files among apache vms, xdebug and phpmyadmin for development, monit for monitoring.


Requirements
------------
Cookbook Dependency:

* ubuntu
* apt
* apt-repo  https://github.com/sometimesfood/chef-apt-repo
* git
* monit  https://github.com/phlipper/chef-monit
* firewall ~> 2.0.2
* ntp
* sudo
* timezone-ii
* apache2 ~> 3.1.0
* php  https://github.com/joelhandwell/chef-php
* php-fpm  https://github.com/yevgenko/cookbook-php-fpm
* xdebug  https://github.com/joelhandwell/xdebug
* phpmyadmin  https://github.com/priestjim/chef-phpmyadmin 
* nfs
* cron
* haproxy  https://github.com/fulloflilies/haproxy 

Supported Platform:
Ubuntu 14.04, Ubuntu 12.04

Usage
-----
#### w_haproxy::default

Include with `w_common` in your node/role's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[w_common]",
    "recipe[w_apache]"
  ]
}
```

Contributing
------------
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Install reqired gems
```
bundle install
```
4. Write your change
5. Write tests for your change (if applicable)
6. Run the tests, ensuring they all pass
```
bundle exec rspec
bundle exec kithen test
```
7. Submit a Pull Request using Github

License and Authors
-------------------
Authors: 
* Joel Handwell @joelhandwell 
* Full Of Lilies @fulloflilies
