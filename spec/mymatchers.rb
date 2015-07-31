def add_monit_config(service)
  ChefSpec::Matchers::ResourceMatcher.new(:monit_monitrc, :create, service)
end

def add_php_fpm(pool)
  ChefSpec::Matchers::ResourceMatcher.new(:php_fpm, :add, pool)
end