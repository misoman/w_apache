require 'spec_helper'

%w( blackfire composer default deploy monit newrelic_app php phpmyadmin ssl varnish_integration vhosts ).each do |test|
  require_relative "../w_apache/#{test}_spec.rb"

  describe "php7 package #{test} installation and configration" do
    include_examples "w_apache::#{test}"
  end
end

%w( mysql mysqli session ).each do |test|
  require_relative "../w_apache/php_ini/#{test}_spec.rb"

  describe "php ini #{test} installation and configration" do
    include_examples "w_apache::php_ini::#{test}"
  end
end
