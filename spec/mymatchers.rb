def add_monit_config(service)
  ChefSpec::Matchers::ResourceMatcher.new(:monit_monitrc, :create, service)
end
