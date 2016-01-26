include_recipe 'apache2::mod_ssl'

certs = data_bag('ssl')

certs.each do |certs_info|

  cert_info = data_bag_item('ssl', certs_info)
  cert_file = "/etc/ssl/certs/#{cert_info['id']}.crt"
  cert_inter_file = "/etc/ssl/certs/#{cert_info['id']}CA.crt"
  cert_key_file = "/etc/ssl/private/#{cert_info['id']}.key"  

  file cert_file do
    content cert_info['cert']
  end
  
  file cert_inter_file do
    content cert_info['cert_inter']
  end
  
  file cert_key_file do
    content cert_info['private_key']
  end
  
  web_app cert_info['id'] + '-ssl' do 
    cookbook 'w_apache'
    template 'ssl.conf.erb'
    server_name cert_info['id']
    server_aliases cert_info['ssl_aliases']
    docroot cert_info['ssl_path']
    ssl_cert_file cert_file
    ssl_cert_inter_file cert_inter_file
    ssl_cert_key_file cert_key_file
    allow_override 'All'
    directory_index ["index.html", "index.htm", "index.php"]
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