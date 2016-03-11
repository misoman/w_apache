include_recipe 'apache2::mod_ssl'

certs = data_bag('ssl')

node['w_common']['web_apps'].each do |web_app|

  vhost = web_app['vhost']

  if vhost.has_key?('ssl') then

    next unless vhost['ssl']

    cert_info = data_bag_item('ssl', vhost['main_domain'])
    cert_file = "/etc/ssl/certs/#{cert_info['id']}.crt"
    cert_key_file = "/etc/ssl/private/#{cert_info['id']}.key"

    file cert_file do
      content cert_info['cert']
    end

    file cert_key_file do
      content cert_info['private_key']
    end

    if cert_info.has_key?('cert_inter') then
      cert_inter_file = "/etc/ssl/certs/#{cert_info['id']}CA.crt"

      file cert_inter_file do
        content cert_info['cert_inter']
      end
    end

    # need to add optin to only enable https, and disable http, and in that case, following code is needed
    # directory vhost['docroot'] do
    #   owner 'www-data'
    #   group 'www-data'
    #   recursive true
    #   not_if { web_app['vhost'].has_key?('create_docroot_dir') && web_app['vhost']['create_docroot_dir'] == false }
    # end

    web_app cert_info['id'] + '-ssl' do
      cookbook 'w_apache'
      template 'ssl.conf.erb'
      server_name vhost['main_domain']
      server_aliases vhost['aliases']
      docroot vhost['docroot']
      ssl_cert_file cert_file
      ssl_cert_inter_file cert_inter_file if cert_info.has_key?('cert_inter')
      ssl_cert_key_file cert_key_file
      allow_override 'All'
      directory_index ["index.html", "index.htm", "index.php"]
    end
  end
end

node.default['apache']['mod_ssl']['pass_phrase_dialog'] = 'exec:/etc/ssl/passphrase'
pass_phrase = data_bag_item('w_apache', 'passphrase')['pass_phrase']

passphrase = <<EOF
#!/bin/sh
echo "#{pass_phrase}"
EOF

file '/etc/ssl/passphrase' do
  content passphrase
  mode '0755'
end
