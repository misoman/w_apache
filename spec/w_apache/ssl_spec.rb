require_relative '../spec_helper'

describe 'w_apache::ssl' do

  let(:cert) {'-----BEGIN CERTIFICATE-----\nGIIE8jCCA9qgAwIBAgIQWtSdpLcAzgsTbR24hRzPADANBgkqhkiG9w0BAQsFADBE\nMQswCQYDVQQGEwJVUzEWMBQGA1UEChMNR2VvVHJ1c3QgSW5jLjEdMBsGA1UEAxMU\nR2VvVHJ1c3QgU1NMIENBIC0gRzMwHhcNMTQwOTI5MDAwMDAwWhcNMTUwOTI5MjM1\nOTU5WjBwMQswCQYDVQQGEwJVUzERMA8GA1UECAwITmV3IFlvcmsxETAPBgNVBAcM\nCE5ldyBZb3JrMRUwEwYDVQQKDAxOZXdzd2VlayBMTEMxCzAJBgNVBAsMAklUMRcw\nFQYDVQQDDA4qLm5ld3N3ZWVrLmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCR\nAQoCggEBAJqyyzxMSyK1nrk50AzODPE3woPz5ydgmktxXbqTgqjINMTH2wz1DM6F\nbbVyN8C8ThpHYTYdLirkU/ljBP6vDRo+/P9JwJf4HvFbiRWEOE/+MpRLYLemz1SO\n/yyEHMfIIRzS5M7v2oEZ+gNmSPavFXqy9QFgr3x4Etod9r7vD+LUcun1j/xICYPk\ntF7bQCJKuFjprO8pjcxDQkBSqVX1efgeKg/iOHa791p5bFs3Pn7s1mdy/EeInXbW\nR4dXzzY5ncx7Kw4HzxViDRFpl8wn/3SgKZHetWQfuxrEBB4IgKY/wXpxAu1iGmkL\nTrUC0kUd0xNe+XL3qJ9IuptEigL6f8sCAwEAAaOCAbIwggGuMCcGA1UdEQQgMB6C\nDioubmV3c3dlZWsuY29tggxuZXdzd2Vlay5jb20wCQYDVR0TBAIwADAOBgNVHQ8B\nAf8EBAMCBaAwKwYDVR0fBCQwIjAgoB6gHIYaaHR0cDovL2duLnN5bWNiLmNvbS9n\nbi5jcmwwgaEGA1UdIASBmTCBljCBkwYKYIZIAYb4RQEHNjCBhDA/BggrBgEFBQcQ\nARYzaHR0cHM6Ly93d3cuZ2VGdHJ1c3QuY29tL3Jlc291cmNlcy9yZXBvc2l0b3J5\nL2xlZ2FsMEEGCCsGAQUFBwICMDUMM2h0dHBzOi8vd3d3Lmdlb3RydXN0LmNvbS9y\nZXNvdXJjZXMvcmVwb3NpdG9yeS9sZWdhbDAdBgNVHSUEFjAUBggrBgEFBQcDAQYI\nKwYBBQUHAwIwHwYDVR0jBBgwFoAU0m/3lvSFP3I8MH0j2oV4m6N8WnwwVwYIKwYB\nBQUHAQEESzBJMB8GCCsGAQUFBzABhhNodHRwOi8vZ24uc3ltY2QuY29tMCYGCCsG\nAQUFBzAChhpodHRwOi8vZ24uc3ltY2IuY29tL2duLmNydDANBgkqhkiG9w0BAQsF\nAAOCAQEAjcYoK1etfhGmF0AHuOhIBfIDyVTRzS5G010xc9eO++HAk2w4WOSY8G2i\nyAydynrcIfDL+UT8tafFSsSbgVaOMe6ID7MOmVFDN84uspxvharsZBGVyDTafRg/\nFGoG7FdBjxtwtLDJ5G6pHZsdDkeKSlzKc+tXix2dgZMq+679E17AwZ3AOz4IqS6x\nZsx8152MbZr2HXb6M1NBIdfq+Xq3mnxu4788bYlIIhyk+VFdSbmKIcIN+u33KsiV\nTxCyjn8zgmhk4UT+JOIp/CIIWq/1hls9F7Ru6ySS/LKBiPYNC7cBnFLr893VUP+Z\nYVgmYnZGn6Sk4ZbbgLoJ1W2ZUuATyQ==\n-----END CERTIFICATE-----'}
  let(:cert_inter) {'-----BEGIN CERTIFICATE-----\nHIIETzCCAzegAwIBAgIDAjpvMA0GCSqGSIb3DQEBCwUAMEIxCzAJBgNVBAYTAlVT\nMRYwFAYDVQQKEw1HZW9UcnVzdCBJbmMuMRswGQYDVQQDExJHZW9UcnVzdCBHbG9i\nYWwgQ0EwHhcNMTMxMTA1MjEzNjUwWhcNMjIwNTIwMjEzNjUwWjBEMQswCQYDVQQG\nEwJVUzEWMBQGA1UEChMNR2VvVHJ1c3QgSW5jLjEdMBsGA1UEAxMUR2VvVHJ1c3Qg\nU1NMIENBIC0gRzMwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDjvn4K\nhqPPa209K6GXrUkkTdd3uTR5CKWeop7eRxKSPX7qGYax6E89X/fQp3eaWx8KA7UZ\nU9ulIZRpY51qTJEMEEe+EfpshiW3qwRoQjgJZfAU2hme+msLq2LvjafvY3AjqK+B\n89FuiGdT7BKkKXWKp/JXPaKDmJfyCn3U50NuMHhiIllZuHEnRaoPZsZVP/oyFysx\njHag+mkUfJ2fWuLrM04QprPtd2PYw5703d95mnrU7t7dmszDt6ldzBE6B7tvl6QB\nI0eVH6N3+liSxsfQvc+TGEK3fveeZerVO8rtrMVwof7UEJrwEgRErBpbeFBFV0xv\nvYDLgVwts7x2oR5lAgMBAAGjggFKMIIBRjAfBgNVHSMEGDAWgBTAephojYn7qwVk\nDBF9qn1luMrMTjAdBgNVHQ4EFgQU0m/3lvSFP3I8MH0j2oV4m6N8WnwwEgYDVR0T\nAQH/BAgwBgEB/wIBADAOBgNVHQ8BAf8EBAMCAQYwNgYDVR0fBC8wLTAroCmgJ4Yl\naHR0cDovL2cxLnN5bWNiLmNvbS9jcmxzL2d0Z2xfYmFsLmNybDAvBggrBgEFBQcB\nAQQjMCEwHwYIKwYBBQUHMAGGE2h0dHA6Ly9nMi5zeW1jYi5jb20wTAYDVR0gBEUw\nQzBBBgpghkgBhvhFAQc2MDMwMQYIKwYBBQUHAgEWJDh0dHA6Ly93d3cuZ2VvdHJ1\nc3QuY29tL3Jlc291cmNlcy9jcHMwKQYDVR0RBCIwIKQeMBwxGjAYBgNVBAMTEVN5\nbWFudGVjUEtJLTEtNTM5MA0GCSqGSIb3DQEBCwUAA4IBAQCg1Pcs+3QLf2TxzUNq\nn2JTHAJ8mJCi7k9o1CAacxI+d7NQ63K87oi+fxfqd4+DYZVPhKHLMk9sIb7SaZZ9\nY73cK6gf0BOEcP72NZWJ+aZ3sEbIu7cT9clgadZM/tKO79NgwYCA4ef7i28heUrg\n3Kkbwbf7w0lZXLV3B0TUl/xJAIlvBk4BcBmsLxHA4uYPL4ZLjXvDuacu9PGsFj45\nSVGeF0tPQDpbpaiSb/361gsDTUdWVxnzy2v189bPsPX1oxHSIFMTNDcFLENaY9+N\nQNaFHlHpURceA1bJ8TCt55sRornQMYGbaLHZ6PPmlH7HrhMvh+3QJbBo+d4IWvMp\nzNSQ\n-----END CERTIFICATE-----'}
  let(:private_key) {'-----BEGIN RSA PRIVATE KEY-----\nProc-Type: 4,ENCRYPTED\nDEK-Info: DES-EDE3-CBC,H7F2CE4EA23BE5B4\n\nvee/I75R0Gyfbz4dgQRwcJNGoBZ9YGscj+rvGgH5/5aj8cOSYigUOUq8wLIpMNyy\nv33fSRZ4SHOnGUDMkyChWaCmPHemwr7q688GdQUjqAIz9TSAKTQyXMy5KcGOPr7v\n2XX0I57WdNFHpeqJEeq88g3HLBMjnosiqcoR+9JMEIyzvW9FY5qKk7MAjXmT2NLm\nF1TO1Dt7jZiiW46ROapor/u5/ADblr0h595qAnzdX518cRIjKSeLUxoVp9N22Q+C\nvwHd+RGfg5X6Ml+YG2E9kiukxOxV7/Zg/SzEcV3/2ZVbzbKhWffz858JYZNiFzX6\nN1utO53MkTr6n2t2iGcW3LMkH4lSC/hnwWUuQEf0HR58RmW6OZ/K0+CEf7IMPl+l\nS+FnQSmoksD6KK8w8GBEUUSc4zSx7x0gWo/e8oFhQqocTzkV5AtormiW1nq4GeQD\nRqQwa440z7sHoMAwiUZdfwJf07hFLAPghu/jqlukwxp17wJG6ga1/ah4Xw/3CINr\nIl6TvW5MevFvrd58hz/MsFanJrdSjKC3cnScDdwSTiYEjOecJMXLl+YkyBmtHrzt\nQTL02cIEtj1d6R6xPliKTWwT0DkyiaKi7H51EMzsaRxLgrgjTzzxBjg1zAB+Nf6x\nS/1oY8M/uEUMjXMIpohbIXkLN0JhVVWoubDDFzp2UqSmS2KgtI/48atTzEMOUW4O\nBndVngsmeroeRTuGmkXbYRKQcNWIf8vZAYNeEXklOL5oxWxGmtwj1wGaNYIb52N+\n5CQ9d2CBBp8S1iN22RPHbIy8Nr36ma79qqjKpgVghICOs71+vBZpDfva35ynpwmr\nvcpS+GfR/tJFAB4R9CwNyOlnHmz6JiZ9Wj74Ovgq+yrNeO8dUF0itP1m/KTU8Shi\nrz5Db1G1cd0biNEwAlVsGgxWRtjeP2OgZwRER/4BZnJLQHkxvCRxI4WmjBqJNYC2\ng4zYLyzyA/g6dPu76cjdHDjiX2/onKvw2H6wcAtUFOcGTTZFkwenOkpegj0nhqoo\nF51OGpW1YN7cG/H3/kQ5g23fmXwRTVGqguBT2TIKM8kMCfmsbgEUQ8UgAsYWyFwd\n1RDlg1k+WfFgpGg+7qa+C11A4qXefgk9mAK0vzHTULPCOmSVWp5k3ozkupsQtBbE\nkNZnDpQmwPd15HSRWWrx3AqSOGSLW70co4KMpSiD81yvu/s+15opRVgEdwMBUeaj\ni28Bjj6750J/SCY9xWUxlkYf4gCNJc5cqR4BrGTNedtr0hiWCQq6XZp1ICu1eVdH\nEd5Bt4LY1iwAsnzL0/P/i9uVkAyJuVpMeC1NUPH7ObcH0rYHYhSHTyJf1QvXg7Aj\n1CbjSfS/0G4hvs1hNp9KuAJ0afCUnIc7pW0iwlnm3DEVtIp686q1Aes+2vna0fog\nbLtci0vaOFXWpSCy7Cp/K/VyxGLiyRWfLCYTn7BHPhr5qPnBuhoF1Tta6c6hys7d\n4G3wYnSiOyDnRSnrWz1oFwHxS9y8oFez1e7gtNoL7z70TsyJo8S7IPkRu2V6Ek7x\n42M83ZW5dVFvGF2TyeDhhMnt3OKv4/zjvAMs9wAgxbNI2uFxCkX/8kYprA1Ptw2o\n-----END RSA PRIVATE KEY-----'}  

  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.normal['w_common']['web_apps'] = web_apps      
      node.normal['w_varnish']['node_ipaddress_list'] = ["7.7.7.7", "8.8.8.8"]
      node.normal['w_apache']['ssl_enabled'] = true
    end.converge(described_recipe)
  end

  before do
    stub_command('/usr/sbin/apache2 -t').and_return(true)
    stub_data_bag('ssl') 
    
    web_apps.each do |web_app| 
      vhost = web_app[:vhost]
      domain = vhost[:main_domain]
      cert_files = {
        'id' => domain,
        'cert' => cert,
        'private_key' => private_key
      }
      cert_files['cert_inter'] = cert_inter unless domain == 'ssl-without-intermediate-cert.com'
      stub_data_bag_item('ssl', domain).and_return(cert_files)
    end

    stub_data_bag_item('w_apache', 'passphrase').and_return('id' => 'passphrase', 'pass_phrase' => 'builtin')
  end

  it 'runs recipe apache2::mod_ssl' do
    expect(chef_run).to include_recipe('apache2::mod_ssl')
  end

  web_apps.each do |web_app|
    vhost = web_app[:vhost]
    next unless vhost.key?(:ssl)

    domain = vhost[:main_domain]
    docroot = vhost[:docroot]

    it "creates file for certificate, intermediate and private key for #{domain}" do

      if domain == 'ssl-disabled.example.com' then
        expect(chef_run).not_to create_file("/etc/ssl/certs/#{domain}.crt").with(content: cert)
        expect(chef_run).not_to create_file("/etc/ssl/private/#{domain}.key").with(content: private_key)
      else
        expect(chef_run).to create_file("/etc/ssl/certs/#{domain}.crt").with(content: cert)
        expect(chef_run).to create_file("/etc/ssl/private/#{domain}.key").with(content: private_key)
      end

      if domain == 'ssl-without-intermediate-cert.com' or domain == 'ssl-disabled.example.com' then
        expect(chef_run).not_to create_file("/etc/ssl/certs/#{domain}CA.crt").with(content: cert_inter)
      else
        expect(chef_run).to create_file("/etc/ssl/certs/#{domain}CA.crt").with(content: cert_inter)
      end
    end

    describe "/etc/apache2/sites-available/#{domain}-ssl.conf" do

      if domain == 'ssl-disabled.example.com' then
        it 'is not created' do
          expect(chef_run).not_to create_template("/etc/apache2/sites-available/#{domain}-ssl.conf")
          expect(chef_run).not_to render_file("/etc/apache2/sites-available/#{domain}-ssl.conf")
        end
      else
        it 'is created with proper contents' do
          expect(chef_run).to create_template("/etc/apache2/sites-available/#{domain}-ssl.conf")
          expect(chef_run).to render_file("/etc/apache2/sites-available/#{domain}-ssl.conf").with_content{ |content|
            expect(content).to match(/ServerName #{domain}/)
            expect(content).to match(/DocumentRoot #{docroot}/)
            if domain == 'ssl.example.com' then
              expect(content).to match(/ServerAlias #{vhost[:aliases].join(' ')}/)
            end
            expect(content).to match(/DirectoryIndex index.html index.htm index.php/)
            expect(content).to match(/AllowOverride All/)
            if domain == 'ssl.example.com' then
              expect(content).to match(/LogLevel warn/)
            else
              expect(content).to match(/LogLevel error/)
            end
          }          
        end
      end
    end
  end

passphrase = <<EOF
#!/bin/sh
echo "builtin"
EOF

  it 'creates file passphrase' do
    expect(chef_run).to create_file('/etc/ssl/passphrase').with(content: passphrase, mode: '0755')
  end
end
