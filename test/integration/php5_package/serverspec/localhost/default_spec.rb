require 'spec_helper'

%w( blackfire composer default deploy monit newrelic_app php phpmyadmin ssl varnish_integration vhosts ).each do |test|
  require_relative "../shared/#{test}_spec.rb"

  describe "php5 package #{test} installation and configration" do
    include_examples "w_apache::#{test}"
  end
end
