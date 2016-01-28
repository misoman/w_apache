require_relative '../spec_helper'

describe 'w_apache::ssl' do

  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set['w_common']['web_apps'] = web_apps
      node.set['w_apache']['deploy']['enabled'] = true
      node.set['w_memcached']['ips'] = ['127.0.0.1']
      node.set['w_varnish']['node_ipaddress_list'] = ["7.7.7.7", "8.8.8.8"]
      node.set['w_apache']['ssl_enabled'] = true
    end.converge(described_recipe)
  end
  
  before do 

    stub_data_bag_item("w_apache", "deploykey").and_return('id' => 'deploykey', 'private_key' => '-----BEGIN RSA PRIVATE KEY-----CVIOpAIBAAKCAQEA4tcgfvo5E7HG3u+Bl1zDHmW+L4vbCE31PlCzPnUA+1iLfb6Sv1x/ibzhVsFXALP0LON5lL2/3wf6B+qH7t6JpsmYo8qsWpmKy2J7pygQYrmHsxhxxaVU2NEhZT/uhWLKzF40yJ74/of5yBxwutoESYEl1YIilPiGJaWMmQtFUlCiHa7iZQ0Rx7w+A/waxnslA1cajwb3T4PdmLK5zPd8c+089BiCXzJgrKsGSJQ0Ea/EemoU2LIwvs75P3e6necmMSpjqaZGr9s87orbKq1pNyh3/QWzn4C3OKj8QX1m/g51YkUvzTSJzLeJMZygrhSCEU4KoqmwMWW8yUmLMs2xLQIBIwKCAQEAlREGudeh2b33txJrGlLmnvJnCU1GyvFmpUr5ci+hjzovx6kemwJFLqCxVkSJoWBQAD22S80mULwZVai/ujp3tr795/o2vzGy+q5ug8ne4cpgfQFvVf7unRu23CKyr2zOaQq0+N1/DanQByih2d+5rKVTYGt1z5wAYeHRa+LVyF+ixRjZh8kl0y74V32MpWoLddDjK4t5Kcqp/YRJ+cZrj0sqZhIKotbowhbzPZm4a9s7tqbsgLzTbKZPDLqibA1sxtC0DjfavaVEG79QWw+ReNJpxXLCK6LuoiOlJTheOkkX9OT0Hmt4UKILtQsNxASzwD6omQT1L1zqj/d1G/dutwKBgQD2UbMPrhxyjQktLCM7EUCcQvs7siyPGzdCxCsYy8fLEYnHD+8BIaqbfdmzpcca5US0UluTUHBG89qshKN8GlhGqGoghxrvT9QOMvL4vz/bx5Bc3CWyAaqR0rLoPMIRyJdhxMP2oDNKw6j3dF1s6KyBlH16zGoVyhse8AJTjXhGYwKBgQDrwXHVmmV77jPv+aqEHa9sLncKu/sI3nE/Gxdc9GXsUK5LoeGHUNyPgeYNAkdZk2tcPqEv5b5lRwJaAICVQ03sF2xoyiAVo5xi6mmfypik72MK3iY+UE2Cm7/V7XvQ8wfY5g6OCdgjxgG3k3xLWFW3TSNMfhaq3G9PKrhkC3i3LwKBgQDvSA0H6vcQMTwdQNHEWeb+MnBl4EiLBH7TJPaqX47ihhDQANmMEhNyekEyLAM+stUG8Os+pelpfywyj3o+CvarCgCx4lSt9cautSaLPXE75m77HwAMAZ5hxV1WoWwRRoRtmpJ6jP6gZkxeGUTQMnuxE+eb3IRPrmN9I6p9DRXAtwKBgQCa7NXG4c2pNiIhWuxlcpfZYFzbKxKuDoTu9IuyHPKFWZcbwiZ9fkfMBOeiJhGhQ55Sj45+j6kAuaJ1qI8DAFfHCBQKWPCDP6FIUOZTEBsqjq7MoJzJ3P+8Ona/x/JHeyJp9kQUMlrVrgEg3UMM8Ofe2utPhg7lTwdRR/WDkoKHAQKBgQDeqRjEqLVs8sHu49PeVY2v/JbDhWHLmyCTP7v8tn9UA/E0JATz8/7lEr5nqGoWx7MK4AYv4QUIRH9eamkMA8TZy7gAPCCb13wllU0ntbD7Dtm0RioxGwnD4GeQEBwIQ4BdMl4wbDmPt9rhBEGkD9vGDkmbU4iHoWK8rC0EHrgCsQ+=-----END RSA PRIVATE KEY-----')
    stub_data_bag_item("w_apache", "jenkinskey").and_return('id' => 'jenkinskey', 'public_key' => 'ssh-rsa BAAAB3NzaC1yc2EAAAADAQABAAABAQDFrcjKWXebaCrE49CikRd1ScSuRdbMuJ6aMxBgg9RuA9c2Lzn70YFguoSXl0xwdhxIG4O+ft6lL4TwJy80J+Hs1cUE/GxemLDYSVwfG61+AqDonYnMRvdeYsWxfTi5lINA60IIUkvv5fNS69FLRoJT8sZdUDX9rF/swuEohcVT3GVUyKfGZtEJcASYwSiHXiyJ3tgfFNTeRZKw/qMWX+bSCUbFAJrTyHzg0FobEVWyUdlUvNXnNI8vlhh6qbnx4cPmRWqsqsEPWe3CjDArzgMs3m5ez0+7S3SrBf3mNqbzH0E/RhsrQqOuHHPVOz/aVlcKEOaSqiBTXwPn9xZjS4lF jenkins@jenkins.examplewebsite.com')
    stub_data_bag_item("w_apache", "gitlabkey").and_return('id' => 'gitlabkey', 'public_key' => 'git.examplewebsite.com ssh-rsa VAAAB3NzaC1yc2EAAAADAQABAAABAQDN5u2/w1xQdJQWD+/omBz4iR8ZUvPiRRgk6O6MYy+vmrPr4w+GyMYfhvDylhW+BIil2mHDaY7XdMrJb1FlUoS4a0WxMbpvqffMlVQoYphtHbtqALCfD6s+KKIcE0nuwYU7gaMRHU9LFxdsjVv2wRGrW79b8u22ySLRdkKu9tSSfkeAWUP7CMiMELVEr1su5mTeR7j1oQUnoRA6w5fsFRtu5PHMS8i/-jdTwoG4JYWKbmVxqhzso+qT2rix4duJJ8LEN35wCkCO/nbTlXExEZovvjE7hNPmA5EULLN/jWy2Vuq0blqDKs6eN6+lzMME2iplNIKZdfvXO+e90zdHnJOK')
    stub_data_bag("ssl").and_return(["ssl.example.com", "ssl-without-intermediate-cert.com"])
    stub_data_bag_item("ssl", "ssl.example.com").and_return(
      'id' => 'ssl.example.com', 
      'cert' => '-----BEGIN CERTIFICATE-----\nGIIE8jCCA9qgAwIBAgIQWtSdpLcAzgsTbR24hRzPADANBgkqhkiG9w0BAQsFADBE\nMQswCQYDVQQGEwJVUzEWMBQGA1UEChMNR2VvVHJ1c3QgSW5jLjEdMBsGA1UEAxMU\nR2VvVHJ1c3QgU1NMIENBIC0gRzMwHhcNMTQwOTI5MDAwMDAwWhcNMTUwOTI5MjM1\nOTU5WjBwMQswCQYDVQQGEwJVUzERMA8GA1UECAwITmV3IFlvcmsxETAPBgNVBAcM\nCE5ldyBZb3JrMRUwEwYDVQQKDAxOZXdzd2VlayBMTEMxCzAJBgNVBAsMAklUMRcw\nFQYDVQQDDA4qLm5ld3N3ZWVrLmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCR\nAQoCggEBAJqyyzxMSyK1nrk50AzODPE3woPz5ydgmktxXbqTgqjINMTH2wz1DM6F\nbbVyN8C8ThpHYTYdLirkU/ljBP6vDRo+/P9JwJf4HvFbiRWEOE/+MpRLYLemz1SO\n/yyEHMfIIRzS5M7v2oEZ+gNmSPavFXqy9QFgr3x4Etod9r7vD+LUcun1j/xICYPk\ntF7bQCJKuFjprO8pjcxDQkBSqVX1efgeKg/iOHa791p5bFs3Pn7s1mdy/EeInXbW\nR4dXzzY5ncx7Kw4HzxViDRFpl8wn/3SgKZHetWQfuxrEBB4IgKY/wXpxAu1iGmkL\nTrUC0kUd0xNe+XL3qJ9IuptEigL6f8sCAwEAAaOCAbIwggGuMCcGA1UdEQQgMB6C\nDioubmV3c3dlZWsuY29tggxuZXdzd2Vlay5jb20wCQYDVR0TBAIwADAOBgNVHQ8B\nAf8EBAMCBaAwKwYDVR0fBCQwIjAgoB6gHIYaaHR0cDovL2duLnN5bWNiLmNvbS9n\nbi5jcmwwgaEGA1UdIASBmTCBljCBkwYKYIZIAYb4RQEHNjCBhDA/BggrBgEFBQcQ\nARYzaHR0cHM6Ly93d3cuZ2VGdHJ1c3QuY29tL3Jlc291cmNlcy9yZXBvc2l0b3J5\nL2xlZ2FsMEEGCCsGAQUFBwICMDUMM2h0dHBzOi8vd3d3Lmdlb3RydXN0LmNvbS9y\nZXNvdXJjZXMvcmVwb3NpdG9yeS9sZWdhbDAdBgNVHSUEFjAUBggrBgEFBQcDAQYI\nKwYBBQUHAwIwHwYDVR0jBBgwFoAU0m/3lvSFP3I8MH0j2oV4m6N8WnwwVwYIKwYB\nBQUHAQEESzBJMB8GCCsGAQUFBzABhhNodHRwOi8vZ24uc3ltY2QuY29tMCYGCCsG\nAQUFBzAChhpodHRwOi8vZ24uc3ltY2IuY29tL2duLmNydDANBgkqhkiG9w0BAQsF\nAAOCAQEAjcYoK1etfhGmF0AHuOhIBfIDyVTRzS5G010xc9eO++HAk2w4WOSY8G2i\nyAydynrcIfDL+UT8tafFSsSbgVaOMe6ID7MOmVFDN84uspxvharsZBGVyDTafRg/\nFGoG7FdBjxtwtLDJ5G6pHZsdDkeKSlzKc+tXix2dgZMq+679E17AwZ3AOz4IqS6x\nZsx8152MbZr2HXb6M1NBIdfq+Xq3mnxu4788bYlIIhyk+VFdSbmKIcIN+u33KsiV\nTxCyjn8zgmhk4UT+JOIp/CIIWq/1hls9F7Ru6ySS/LKBiPYNC7cBnFLr893VUP+Z\nYVgmYnZGn6Sk4ZbbgLoJ1W2ZUuATyQ==\n-----END CERTIFICATE-----', 
      'cert_inter' => '-----BEGIN CERTIFICATE-----\nHIIETzCCAzegAwIBAgIDAjpvMA0GCSqGSIb3DQEBCwUAMEIxCzAJBgNVBAYTAlVT\nMRYwFAYDVQQKEw1HZW9UcnVzdCBJbmMuMRswGQYDVQQDExJHZW9UcnVzdCBHbG9i\nYWwgQ0EwHhcNMTMxMTA1MjEzNjUwWhcNMjIwNTIwMjEzNjUwWjBEMQswCQYDVQQG\nEwJVUzEWMBQGA1UEChMNR2VvVHJ1c3QgSW5jLjEdMBsGA1UEAxMUR2VvVHJ1c3Qg\nU1NMIENBIC0gRzMwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDjvn4K\nhqPPa209K6GXrUkkTdd3uTR5CKWeop7eRxKSPX7qGYax6E89X/fQp3eaWx8KA7UZ\nU9ulIZRpY51qTJEMEEe+EfpshiW3qwRoQjgJZfAU2hme+msLq2LvjafvY3AjqK+B\n89FuiGdT7BKkKXWKp/JXPaKDmJfyCn3U50NuMHhiIllZuHEnRaoPZsZVP/oyFysx\njHag+mkUfJ2fWuLrM04QprPtd2PYw5703d95mnrU7t7dmszDt6ldzBE6B7tvl6QB\nI0eVH6N3+liSxsfQvc+TGEK3fveeZerVO8rtrMVwof7UEJrwEgRErBpbeFBFV0xv\nvYDLgVwts7x2oR5lAgMBAAGjggFKMIIBRjAfBgNVHSMEGDAWgBTAephojYn7qwVk\nDBF9qn1luMrMTjAdBgNVHQ4EFgQU0m/3lvSFP3I8MH0j2oV4m6N8WnwwEgYDVR0T\nAQH/BAgwBgEB/wIBADAOBgNVHQ8BAf8EBAMCAQYwNgYDVR0fBC8wLTAroCmgJ4Yl\naHR0cDovL2cxLnN5bWNiLmNvbS9jcmxzL2d0Z2xfYmFsLmNybDAvBggrBgEFBQcB\nAQQjMCEwHwYIKwYBBQUHMAGGE2h0dHA6Ly9nMi5zeW1jYi5jb20wTAYDVR0gBEUw\nQzBBBgpghkgBhvhFAQc2MDMwMQYIKwYBBQUHAgEWJDh0dHA6Ly93d3cuZ2VvdHJ1\nc3QuY29tL3Jlc291cmNlcy9jcHMwKQYDVR0RBCIwIKQeMBwxGjAYBgNVBAMTEVN5\nbWFudGVjUEtJLTEtNTM5MA0GCSqGSIb3DQEBCwUAA4IBAQCg1Pcs+3QLf2TxzUNq\nn2JTHAJ8mJCi7k9o1CAacxI+d7NQ63K87oi+fxfqd4+DYZVPhKHLMk9sIb7SaZZ9\nY73cK6gf0BOEcP72NZWJ+aZ3sEbIu7cT9clgadZM/tKO79NgwYCA4ef7i28heUrg\n3Kkbwbf7w0lZXLV3B0TUl/xJAIlvBk4BcBmsLxHA4uYPL4ZLjXvDuacu9PGsFj45\nSVGeF0tPQDpbpaiSb/361gsDTUdWVxnzy2v189bPsPX1oxHSIFMTNDcFLENaY9+N\nQNaFHlHpURceA1bJ8TCt55sRornQMYGbaLHZ6PPmlH7HrhMvh+3QJbBo+d4IWvMp\nzNSQ\n-----END CERTIFICATE-----', 
      'private_key' => '-----BEGIN RSA PRIVATE KEY-----\nProc-Type: 4,ENCRYPTED\nDEK-Info: DES-EDE3-CBC,H7F2CE4EA23BE5B4\n\nvee/I75R0Gyfbz4dgQRwcJNGoBZ9YGscj+rvGgH5/5aj8cOSYigUOUq8wLIpMNyy\nv33fSRZ4SHOnGUDMkyChWaCmPHemwr7q688GdQUjqAIz9TSAKTQyXMy5KcGOPr7v\n2XX0I57WdNFHpeqJEeq88g3HLBMjnosiqcoR+9JMEIyzvW9FY5qKk7MAjXmT2NLm\nF1TO1Dt7jZiiW46ROapor/u5/ADblr0h595qAnzdX518cRIjKSeLUxoVp9N22Q+C\nvwHd+RGfg5X6Ml+YG2E9kiukxOxV7/Zg/SzEcV3/2ZVbzbKhWffz858JYZNiFzX6\nN1utO53MkTr6n2t2iGcW3LMkH4lSC/hnwWUuQEf0HR58RmW6OZ/K0+CEf7IMPl+l\nS+FnQSmoksD6KK8w8GBEUUSc4zSx7x0gWo/e8oFhQqocTzkV5AtormiW1nq4GeQD\nRqQwa440z7sHoMAwiUZdfwJf07hFLAPghu/jqlukwxp17wJG6ga1/ah4Xw/3CINr\nIl6TvW5MevFvrd58hz/MsFanJrdSjKC3cnScDdwSTiYEjOecJMXLl+YkyBmtHrzt\nQTL02cIEtj1d6R6xPliKTWwT0DkyiaKi7H51EMzsaRxLgrgjTzzxBjg1zAB+Nf6x\nS/1oY8M/uEUMjXMIpohbIXkLN0JhVVWoubDDFzp2UqSmS2KgtI/48atTzEMOUW4O\nBndVngsmeroeRTuGmkXbYRKQcNWIf8vZAYNeEXklOL5oxWxGmtwj1wGaNYIb52N+\n5CQ9d2CBBp8S1iN22RPHbIy8Nr36ma79qqjKpgVghICOs71+vBZpDfva35ynpwmr\nvcpS+GfR/tJFAB4R9CwNyOlnHmz6JiZ9Wj74Ovgq+yrNeO8dUF0itP1m/KTU8Shi\nrz5Db1G1cd0biNEwAlVsGgxWRtjeP2OgZwRER/4BZnJLQHkxvCRxI4WmjBqJNYC2\ng4zYLyzyA/g6dPu76cjdHDjiX2/onKvw2H6wcAtUFOcGTTZFkwenOkpegj0nhqoo\nF51OGpW1YN7cG/H3/kQ5g23fmXwRTVGqguBT2TIKM8kMCfmsbgEUQ8UgAsYWyFwd\n1RDlg1k+WfFgpGg+7qa+C11A4qXefgk9mAK0vzHTULPCOmSVWp5k3ozkupsQtBbE\nkNZnDpQmwPd15HSRWWrx3AqSOGSLW70co4KMpSiD81yvu/s+15opRVgEdwMBUeaj\ni28Bjj6750J/SCY9xWUxlkYf4gCNJc5cqR4BrGTNedtr0hiWCQq6XZp1ICu1eVdH\nEd5Bt4LY1iwAsnzL0/P/i9uVkAyJuVpMeC1NUPH7ObcH0rYHYhSHTyJf1QvXg7Aj\n1CbjSfS/0G4hvs1hNp9KuAJ0afCUnIc7pW0iwlnm3DEVtIp686q1Aes+2vna0fog\nbLtci0vaOFXWpSCy7Cp/K/VyxGLiyRWfLCYTn7BHPhr5qPnBuhoF1Tta6c6hys7d\n4G3wYnSiOyDnRSnrWz1oFwHxS9y8oFez1e7gtNoL7z70TsyJo8S7IPkRu2V6Ek7x\n42M83ZW5dVFvGF2TyeDhhMnt3OKv4/zjvAMs9wAgxbNI2uFxCkX/8kYprA1Ptw2o\n-----END RSA PRIVATE KEY-----')
    stub_data_bag_item("ssl", "ssl-without-intermediate-cert.com").and_return(
      'id' => 'ssl-without-intermediate-cert.com', 
      'cert' => '-----BEGIN CERTIFICATE-----\nGIIE8jCCA9qgAwIBAgIQWtSdpLcAzgsTbR24hRzPADANBgkqhkiG9w0BAQsFADBE\nMQswCQYDVQQGEwJVUzEWMBQGA1UEChMNR2VvVHJ1c3QgSW5jLjEdMBsGA1UEAxMU\nR2VvVHJ1c3QgU1NMIENBIC0gRzMwHhcNMTQwOTI5MDAwMDAwWhcNMTUwOTI5MjM1\nOTU5WjBwMQswCQYDVQQGEwJVUzERMA8GA1UECAwITmV3IFlvcmsxETAPBgNVBAcM\nCE5ldyBZb3JrMRUwEwYDVQQKDAxOZXdzd2VlayBMTEMxCzAJBgNVBAsMAklUMRcw\nFQYDVQQDDA4qLm5ld3N3ZWVrLmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCR\nAQoCggEBAJqyyzxMSyK1nrk50AzODPE3woPz5ydgmktxXbqTgqjINMTH2wz1DM6F\nbbVyN8C8ThpHYTYdLirkU/ljBP6vDRo+/P9JwJf4HvFbiRWEOE/+MpRLYLemz1SO\n/yyEHMfIIRzS5M7v2oEZ+gNmSPavFXqy9QFgr3x4Etod9r7vD+LUcun1j/xICYPk\ntF7bQCJKuFjprO8pjcxDQkBSqVX1efgeKg/iOHa791p5bFs3Pn7s1mdy/EeInXbW\nR4dXzzY5ncx7Kw4HzxViDRFpl8wn/3SgKZHetWQfuxrEBB4IgKY/wXpxAu1iGmkL\nTrUC0kUd0xNe+XL3qJ9IuptEigL6f8sCAwEAAaOCAbIwggGuMCcGA1UdEQQgMB6C\nDioubmV3c3dlZWsuY29tggxuZXdzd2Vlay5jb20wCQYDVR0TBAIwADAOBgNVHQ8B\nAf8EBAMCBaAwKwYDVR0fBCQwIjAgoB6gHIYaaHR0cDovL2duLnN5bWNiLmNvbS9n\nbi5jcmwwgaEGA1UdIASBmTCBljCBkwYKYIZIAYb4RQEHNjCBhDA/BggrBgEFBQcQ\nARYzaHR0cHM6Ly93d3cuZ2VGdHJ1c3QuY29tL3Jlc291cmNlcy9yZXBvc2l0b3J5\nL2xlZ2FsMEEGCCsGAQUFBwICMDUMM2h0dHBzOi8vd3d3Lmdlb3RydXN0LmNvbS9y\nZXNvdXJjZXMvcmVwb3NpdG9yeS9sZWdhbDAdBgNVHSUEFjAUBggrBgEFBQcDAQYI\nKwYBBQUHAwIwHwYDVR0jBBgwFoAU0m/3lvSFP3I8MH0j2oV4m6N8WnwwVwYIKwYB\nBQUHAQEESzBJMB8GCCsGAQUFBzABhhNodHRwOi8vZ24uc3ltY2QuY29tMCYGCCsG\nAQUFBzAChhpodHRwOi8vZ24uc3ltY2IuY29tL2duLmNydDANBgkqhkiG9w0BAQsF\nAAOCAQEAjcYoK1etfhGmF0AHuOhIBfIDyVTRzS5G010xc9eO++HAk2w4WOSY8G2i\nyAydynrcIfDL+UT8tafFSsSbgVaOMe6ID7MOmVFDN84uspxvharsZBGVyDTafRg/\nFGoG7FdBjxtwtLDJ5G6pHZsdDkeKSlzKc+tXix2dgZMq+679E17AwZ3AOz4IqS6x\nZsx8152MbZr2HXb6M1NBIdfq+Xq3mnxu4788bYlIIhyk+VFdSbmKIcIN+u33KsiV\nTxCyjn8zgmhk4UT+JOIp/CIIWq/1hls9F7Ru6ySS/LKBiPYNC7cBnFLr893VUP+Z\nYVgmYnZGn6Sk4ZbbgLoJ1W2ZUuATyQ==\n-----END CERTIFICATE-----', 
    # there is no intermediate certificate
      'private_key' => '-----BEGIN RSA PRIVATE KEY-----\nProc-Type: 4,ENCRYPTED\nDEK-Info: DES-EDE3-CBC,H7F2CE4EA23BE5B4\n\nvee/I75R0Gyfbz4dgQRwcJNGoBZ9YGscj+rvGgH5/5aj8cOSYigUOUq8wLIpMNyy\nv33fSRZ4SHOnGUDMkyChWaCmPHemwr7q688GdQUjqAIz9TSAKTQyXMy5KcGOPr7v\n2XX0I57WdNFHpeqJEeq88g3HLBMjnosiqcoR+9JMEIyzvW9FY5qKk7MAjXmT2NLm\nF1TO1Dt7jZiiW46ROapor/u5/ADblr0h595qAnzdX518cRIjKSeLUxoVp9N22Q+C\nvwHd+RGfg5X6Ml+YG2E9kiukxOxV7/Zg/SzEcV3/2ZVbzbKhWffz858JYZNiFzX6\nN1utO53MkTr6n2t2iGcW3LMkH4lSC/hnwWUuQEf0HR58RmW6OZ/K0+CEf7IMPl+l\nS+FnQSmoksD6KK8w8GBEUUSc4zSx7x0gWo/e8oFhQqocTzkV5AtormiW1nq4GeQD\nRqQwa440z7sHoMAwiUZdfwJf07hFLAPghu/jqlukwxp17wJG6ga1/ah4Xw/3CINr\nIl6TvW5MevFvrd58hz/MsFanJrdSjKC3cnScDdwSTiYEjOecJMXLl+YkyBmtHrzt\nQTL02cIEtj1d6R6xPliKTWwT0DkyiaKi7H51EMzsaRxLgrgjTzzxBjg1zAB+Nf6x\nS/1oY8M/uEUMjXMIpohbIXkLN0JhVVWoubDDFzp2UqSmS2KgtI/48atTzEMOUW4O\nBndVngsmeroeRTuGmkXbYRKQcNWIf8vZAYNeEXklOL5oxWxGmtwj1wGaNYIb52N+\n5CQ9d2CBBp8S1iN22RPHbIy8Nr36ma79qqjKpgVghICOs71+vBZpDfva35ynpwmr\nvcpS+GfR/tJFAB4R9CwNyOlnHmz6JiZ9Wj74Ovgq+yrNeO8dUF0itP1m/KTU8Shi\nrz5Db1G1cd0biNEwAlVsGgxWRtjeP2OgZwRER/4BZnJLQHkxvCRxI4WmjBqJNYC2\ng4zYLyzyA/g6dPu76cjdHDjiX2/onKvw2H6wcAtUFOcGTTZFkwenOkpegj0nhqoo\nF51OGpW1YN7cG/H3/kQ5g23fmXwRTVGqguBT2TIKM8kMCfmsbgEUQ8UgAsYWyFwd\n1RDlg1k+WfFgpGg+7qa+C11A4qXefgk9mAK0vzHTULPCOmSVWp5k3ozkupsQtBbE\nkNZnDpQmwPd15HSRWWrx3AqSOGSLW70co4KMpSiD81yvu/s+15opRVgEdwMBUeaj\ni28Bjj6750J/SCY9xWUxlkYf4gCNJc5cqR4BrGTNedtr0hiWCQq6XZp1ICu1eVdH\nEd5Bt4LY1iwAsnzL0/P/i9uVkAyJuVpMeC1NUPH7ObcH0rYHYhSHTyJf1QvXg7Aj\n1CbjSfS/0G4hvs1hNp9KuAJ0afCUnIc7pW0iwlnm3DEVtIp686q1Aes+2vna0fog\nbLtci0vaOFXWpSCy7Cp/K/VyxGLiyRWfLCYTn7BHPhr5qPnBuhoF1Tta6c6hys7d\n4G3wYnSiOyDnRSnrWz1oFwHxS9y8oFez1e7gtNoL7z70TsyJo8S7IPkRu2V6Ek7x\n42M83ZW5dVFvGF2TyeDhhMnt3OKv4/zjvAMs9wAgxbNI2uFxCkX/8kYprA1Ptw2o\n-----END RSA PRIVATE KEY-----')
     stub_data_bag_item("w_apache", "passphrase").and_return('id' => 'passphrase', 'pass_phrase' => 'builtin')
     
     stub_command("cat /var/www/.ssh/authorized_keys | grep \"ssh-rsa BAAAB3NzaC1yc2EAAAADAQABAAABAQDFrcjKWXebaCrE49CikRd1ScSuRdbMuJ6aMxBgg9RuA9c2Lzn70YFguoSXl0xwdhxIG4O+ft6lL4TwJy80J+Hs1cUE/GxemLDYSVwfG61+AqDonYnMRvdeYsWxfTi5lINA60IIUkvv5fNS69FLRoJT8sZdUDX9rF/swuEohcVT3GVUyKfGZtEJcASYwSiHXiyJ3tgfFNTeRZKw/qMWX+bSCUbFAJrTyHzg0FobEVWyUdlUvNXnNI8vlhh6qbnx4cPmRWqsqsEPWe3CjDArzgMs3m5ez0+7S3SrBf3mNqbzH0E/RhsrQqOuHHPVOz/aVlcKEOaSqiBTXwPn9xZjS4lF jenkins@jenkins.examplewebsite.com\"").and_return(false)
     stub_command("cat /var/www/.ssh/known_hosts | grep \"git.examplewebsite.com ssh-rsa VAAAB3NzaC1yc2EAAAADAQABAAABAQDN5u2/w1xQdJQWD+/omBz4iR8ZUvPiRRgk6O6MYy+vmrPr4w+GyMYfhvDylhW+BIil2mHDaY7XdMrJb1FlUoS4a0WxMbpvqffMlVQoYphtHbtqALCfD6s+KKIcE0nuwYU7gaMRHU9LFxdsjVv2wRGrW79b8u22ySLRdkKu9tSSfkeAWUP7CMiMELVEr1su5mTeR7j1oQUnoRA6w5fsFRtu5PHMS8i/-jdTwoG4JYWKbmVxqhzso+qT2rix4duJJ8LEN35wCkCO/nbTlXExEZovvjE7hNPmA5EULLN/jWy2Vuq0blqDKs6eN6+lzMME2iplNIKZdfvXO+e90zdHnJOK\"").and_return(false)
    stub_command("/usr/sbin/apache2 -t").and_return(true)
    stub_command("cat /websites/example.com/.git/config | grep https://git.examplewebsite.com/www.git").and_return(false)
    stub_command("cat /websites/example2.com/.git/config | grep https://git.examplewebsite.com/www2.git").and_return(false)
    stub_command("cat /websites/example3.com/.git/config | grep https://git.examplewebsite.com/www3.git").and_return(false)
  
  end
    
  it 'runs recipe apache2::mod_ssl' do
    expect(chef_run).to include_recipe('apache2::mod_ssl')
  end
 
  it 'creates file for certificate, intermediate and private key for ssl.example.com' do
  	expect(chef_run).to create_file('/etc/ssl/certs/ssl.example.com.crt').with(content: '-----BEGIN CERTIFICATE-----\nGIIE8jCCA9qgAwIBAgIQWtSdpLcAzgsTbR24hRzPADANBgkqhkiG9w0BAQsFADBE\nMQswCQYDVQQGEwJVUzEWMBQGA1UEChMNR2VvVHJ1c3QgSW5jLjEdMBsGA1UEAxMU\nR2VvVHJ1c3QgU1NMIENBIC0gRzMwHhcNMTQwOTI5MDAwMDAwWhcNMTUwOTI5MjM1\nOTU5WjBwMQswCQYDVQQGEwJVUzERMA8GA1UECAwITmV3IFlvcmsxETAPBgNVBAcM\nCE5ldyBZb3JrMRUwEwYDVQQKDAxOZXdzd2VlayBMTEMxCzAJBgNVBAsMAklUMRcw\nFQYDVQQDDA4qLm5ld3N3ZWVrLmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCR\nAQoCggEBAJqyyzxMSyK1nrk50AzODPE3woPz5ydgmktxXbqTgqjINMTH2wz1DM6F\nbbVyN8C8ThpHYTYdLirkU/ljBP6vDRo+/P9JwJf4HvFbiRWEOE/+MpRLYLemz1SO\n/yyEHMfIIRzS5M7v2oEZ+gNmSPavFXqy9QFgr3x4Etod9r7vD+LUcun1j/xICYPk\ntF7bQCJKuFjprO8pjcxDQkBSqVX1efgeKg/iOHa791p5bFs3Pn7s1mdy/EeInXbW\nR4dXzzY5ncx7Kw4HzxViDRFpl8wn/3SgKZHetWQfuxrEBB4IgKY/wXpxAu1iGmkL\nTrUC0kUd0xNe+XL3qJ9IuptEigL6f8sCAwEAAaOCAbIwggGuMCcGA1UdEQQgMB6C\nDioubmV3c3dlZWsuY29tggxuZXdzd2Vlay5jb20wCQYDVR0TBAIwADAOBgNVHQ8B\nAf8EBAMCBaAwKwYDVR0fBCQwIjAgoB6gHIYaaHR0cDovL2duLnN5bWNiLmNvbS9n\nbi5jcmwwgaEGA1UdIASBmTCBljCBkwYKYIZIAYb4RQEHNjCBhDA/BggrBgEFBQcQ\nARYzaHR0cHM6Ly93d3cuZ2VGdHJ1c3QuY29tL3Jlc291cmNlcy9yZXBvc2l0b3J5\nL2xlZ2FsMEEGCCsGAQUFBwICMDUMM2h0dHBzOi8vd3d3Lmdlb3RydXN0LmNvbS9y\nZXNvdXJjZXMvcmVwb3NpdG9yeS9sZWdhbDAdBgNVHSUEFjAUBggrBgEFBQcDAQYI\nKwYBBQUHAwIwHwYDVR0jBBgwFoAU0m/3lvSFP3I8MH0j2oV4m6N8WnwwVwYIKwYB\nBQUHAQEESzBJMB8GCCsGAQUFBzABhhNodHRwOi8vZ24uc3ltY2QuY29tMCYGCCsG\nAQUFBzAChhpodHRwOi8vZ24uc3ltY2IuY29tL2duLmNydDANBgkqhkiG9w0BAQsF\nAAOCAQEAjcYoK1etfhGmF0AHuOhIBfIDyVTRzS5G010xc9eO++HAk2w4WOSY8G2i\nyAydynrcIfDL+UT8tafFSsSbgVaOMe6ID7MOmVFDN84uspxvharsZBGVyDTafRg/\nFGoG7FdBjxtwtLDJ5G6pHZsdDkeKSlzKc+tXix2dgZMq+679E17AwZ3AOz4IqS6x\nZsx8152MbZr2HXb6M1NBIdfq+Xq3mnxu4788bYlIIhyk+VFdSbmKIcIN+u33KsiV\nTxCyjn8zgmhk4UT+JOIp/CIIWq/1hls9F7Ru6ySS/LKBiPYNC7cBnFLr893VUP+Z\nYVgmYnZGn6Sk4ZbbgLoJ1W2ZUuATyQ==\n-----END CERTIFICATE-----')
  	expect(chef_run).to create_file('/etc/ssl/certs/ssl.example.comCA.crt').with(content: '-----BEGIN CERTIFICATE-----\nHIIETzCCAzegAwIBAgIDAjpvMA0GCSqGSIb3DQEBCwUAMEIxCzAJBgNVBAYTAlVT\nMRYwFAYDVQQKEw1HZW9UcnVzdCBJbmMuMRswGQYDVQQDExJHZW9UcnVzdCBHbG9i\nYWwgQ0EwHhcNMTMxMTA1MjEzNjUwWhcNMjIwNTIwMjEzNjUwWjBEMQswCQYDVQQG\nEwJVUzEWMBQGA1UEChMNR2VvVHJ1c3QgSW5jLjEdMBsGA1UEAxMUR2VvVHJ1c3Qg\nU1NMIENBIC0gRzMwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDjvn4K\nhqPPa209K6GXrUkkTdd3uTR5CKWeop7eRxKSPX7qGYax6E89X/fQp3eaWx8KA7UZ\nU9ulIZRpY51qTJEMEEe+EfpshiW3qwRoQjgJZfAU2hme+msLq2LvjafvY3AjqK+B\n89FuiGdT7BKkKXWKp/JXPaKDmJfyCn3U50NuMHhiIllZuHEnRaoPZsZVP/oyFysx\njHag+mkUfJ2fWuLrM04QprPtd2PYw5703d95mnrU7t7dmszDt6ldzBE6B7tvl6QB\nI0eVH6N3+liSxsfQvc+TGEK3fveeZerVO8rtrMVwof7UEJrwEgRErBpbeFBFV0xv\nvYDLgVwts7x2oR5lAgMBAAGjggFKMIIBRjAfBgNVHSMEGDAWgBTAephojYn7qwVk\nDBF9qn1luMrMTjAdBgNVHQ4EFgQU0m/3lvSFP3I8MH0j2oV4m6N8WnwwEgYDVR0T\nAQH/BAgwBgEB/wIBADAOBgNVHQ8BAf8EBAMCAQYwNgYDVR0fBC8wLTAroCmgJ4Yl\naHR0cDovL2cxLnN5bWNiLmNvbS9jcmxzL2d0Z2xfYmFsLmNybDAvBggrBgEFBQcB\nAQQjMCEwHwYIKwYBBQUHMAGGE2h0dHA6Ly9nMi5zeW1jYi5jb20wTAYDVR0gBEUw\nQzBBBgpghkgBhvhFAQc2MDMwMQYIKwYBBQUHAgEWJDh0dHA6Ly93d3cuZ2VvdHJ1\nc3QuY29tL3Jlc291cmNlcy9jcHMwKQYDVR0RBCIwIKQeMBwxGjAYBgNVBAMTEVN5\nbWFudGVjUEtJLTEtNTM5MA0GCSqGSIb3DQEBCwUAA4IBAQCg1Pcs+3QLf2TxzUNq\nn2JTHAJ8mJCi7k9o1CAacxI+d7NQ63K87oi+fxfqd4+DYZVPhKHLMk9sIb7SaZZ9\nY73cK6gf0BOEcP72NZWJ+aZ3sEbIu7cT9clgadZM/tKO79NgwYCA4ef7i28heUrg\n3Kkbwbf7w0lZXLV3B0TUl/xJAIlvBk4BcBmsLxHA4uYPL4ZLjXvDuacu9PGsFj45\nSVGeF0tPQDpbpaiSb/361gsDTUdWVxnzy2v189bPsPX1oxHSIFMTNDcFLENaY9+N\nQNaFHlHpURceA1bJ8TCt55sRornQMYGbaLHZ6PPmlH7HrhMvh+3QJbBo+d4IWvMp\nzNSQ\n-----END CERTIFICATE-----')
  	expect(chef_run).to create_file('/etc/ssl/private/ssl.example.com.key').with(content: '-----BEGIN RSA PRIVATE KEY-----\nProc-Type: 4,ENCRYPTED\nDEK-Info: DES-EDE3-CBC,H7F2CE4EA23BE5B4\n\nvee/I75R0Gyfbz4dgQRwcJNGoBZ9YGscj+rvGgH5/5aj8cOSYigUOUq8wLIpMNyy\nv33fSRZ4SHOnGUDMkyChWaCmPHemwr7q688GdQUjqAIz9TSAKTQyXMy5KcGOPr7v\n2XX0I57WdNFHpeqJEeq88g3HLBMjnosiqcoR+9JMEIyzvW9FY5qKk7MAjXmT2NLm\nF1TO1Dt7jZiiW46ROapor/u5/ADblr0h595qAnzdX518cRIjKSeLUxoVp9N22Q+C\nvwHd+RGfg5X6Ml+YG2E9kiukxOxV7/Zg/SzEcV3/2ZVbzbKhWffz858JYZNiFzX6\nN1utO53MkTr6n2t2iGcW3LMkH4lSC/hnwWUuQEf0HR58RmW6OZ/K0+CEf7IMPl+l\nS+FnQSmoksD6KK8w8GBEUUSc4zSx7x0gWo/e8oFhQqocTzkV5AtormiW1nq4GeQD\nRqQwa440z7sHoMAwiUZdfwJf07hFLAPghu/jqlukwxp17wJG6ga1/ah4Xw/3CINr\nIl6TvW5MevFvrd58hz/MsFanJrdSjKC3cnScDdwSTiYEjOecJMXLl+YkyBmtHrzt\nQTL02cIEtj1d6R6xPliKTWwT0DkyiaKi7H51EMzsaRxLgrgjTzzxBjg1zAB+Nf6x\nS/1oY8M/uEUMjXMIpohbIXkLN0JhVVWoubDDFzp2UqSmS2KgtI/48atTzEMOUW4O\nBndVngsmeroeRTuGmkXbYRKQcNWIf8vZAYNeEXklOL5oxWxGmtwj1wGaNYIb52N+\n5CQ9d2CBBp8S1iN22RPHbIy8Nr36ma79qqjKpgVghICOs71+vBZpDfva35ynpwmr\nvcpS+GfR/tJFAB4R9CwNyOlnHmz6JiZ9Wj74Ovgq+yrNeO8dUF0itP1m/KTU8Shi\nrz5Db1G1cd0biNEwAlVsGgxWRtjeP2OgZwRER/4BZnJLQHkxvCRxI4WmjBqJNYC2\ng4zYLyzyA/g6dPu76cjdHDjiX2/onKvw2H6wcAtUFOcGTTZFkwenOkpegj0nhqoo\nF51OGpW1YN7cG/H3/kQ5g23fmXwRTVGqguBT2TIKM8kMCfmsbgEUQ8UgAsYWyFwd\n1RDlg1k+WfFgpGg+7qa+C11A4qXefgk9mAK0vzHTULPCOmSVWp5k3ozkupsQtBbE\nkNZnDpQmwPd15HSRWWrx3AqSOGSLW70co4KMpSiD81yvu/s+15opRVgEdwMBUeaj\ni28Bjj6750J/SCY9xWUxlkYf4gCNJc5cqR4BrGTNedtr0hiWCQq6XZp1ICu1eVdH\nEd5Bt4LY1iwAsnzL0/P/i9uVkAyJuVpMeC1NUPH7ObcH0rYHYhSHTyJf1QvXg7Aj\n1CbjSfS/0G4hvs1hNp9KuAJ0afCUnIc7pW0iwlnm3DEVtIp686q1Aes+2vna0fog\nbLtci0vaOFXWpSCy7Cp/K/VyxGLiyRWfLCYTn7BHPhr5qPnBuhoF1Tta6c6hys7d\n4G3wYnSiOyDnRSnrWz1oFwHxS9y8oFez1e7gtNoL7z70TsyJo8S7IPkRu2V6Ek7x\n42M83ZW5dVFvGF2TyeDhhMnt3OKv4/zjvAMs9wAgxbNI2uFxCkX/8kYprA1Ptw2o\n-----END RSA PRIVATE KEY-----')
  end

  it 'creates file for certificate and private key for ssl-without-intermediate-cert.com without intermediate cert' do
  	expect(chef_run).to create_file('/etc/ssl/certs/ssl-without-intermediate-cert.com.crt').with(content: '-----BEGIN CERTIFICATE-----\nGIIE8jCCA9qgAwIBAgIQWtSdpLcAzgsTbR24hRzPADANBgkqhkiG9w0BAQsFADBE\nMQswCQYDVQQGEwJVUzEWMBQGA1UEChMNR2VvVHJ1c3QgSW5jLjEdMBsGA1UEAxMU\nR2VvVHJ1c3QgU1NMIENBIC0gRzMwHhcNMTQwOTI5MDAwMDAwWhcNMTUwOTI5MjM1\nOTU5WjBwMQswCQYDVQQGEwJVUzERMA8GA1UECAwITmV3IFlvcmsxETAPBgNVBAcM\nCE5ldyBZb3JrMRUwEwYDVQQKDAxOZXdzd2VlayBMTEMxCzAJBgNVBAsMAklUMRcw\nFQYDVQQDDA4qLm5ld3N3ZWVrLmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCR\nAQoCggEBAJqyyzxMSyK1nrk50AzODPE3woPz5ydgmktxXbqTgqjINMTH2wz1DM6F\nbbVyN8C8ThpHYTYdLirkU/ljBP6vDRo+/P9JwJf4HvFbiRWEOE/+MpRLYLemz1SO\n/yyEHMfIIRzS5M7v2oEZ+gNmSPavFXqy9QFgr3x4Etod9r7vD+LUcun1j/xICYPk\ntF7bQCJKuFjprO8pjcxDQkBSqVX1efgeKg/iOHa791p5bFs3Pn7s1mdy/EeInXbW\nR4dXzzY5ncx7Kw4HzxViDRFpl8wn/3SgKZHetWQfuxrEBB4IgKY/wXpxAu1iGmkL\nTrUC0kUd0xNe+XL3qJ9IuptEigL6f8sCAwEAAaOCAbIwggGuMCcGA1UdEQQgMB6C\nDioubmV3c3dlZWsuY29tggxuZXdzd2Vlay5jb20wCQYDVR0TBAIwADAOBgNVHQ8B\nAf8EBAMCBaAwKwYDVR0fBCQwIjAgoB6gHIYaaHR0cDovL2duLnN5bWNiLmNvbS9n\nbi5jcmwwgaEGA1UdIASBmTCBljCBkwYKYIZIAYb4RQEHNjCBhDA/BggrBgEFBQcQ\nARYzaHR0cHM6Ly93d3cuZ2VGdHJ1c3QuY29tL3Jlc291cmNlcy9yZXBvc2l0b3J5\nL2xlZ2FsMEEGCCsGAQUFBwICMDUMM2h0dHBzOi8vd3d3Lmdlb3RydXN0LmNvbS9y\nZXNvdXJjZXMvcmVwb3NpdG9yeS9sZWdhbDAdBgNVHSUEFjAUBggrBgEFBQcDAQYI\nKwYBBQUHAwIwHwYDVR0jBBgwFoAU0m/3lvSFP3I8MH0j2oV4m6N8WnwwVwYIKwYB\nBQUHAQEESzBJMB8GCCsGAQUFBzABhhNodHRwOi8vZ24uc3ltY2QuY29tMCYGCCsG\nAQUFBzAChhpodHRwOi8vZ24uc3ltY2IuY29tL2duLmNydDANBgkqhkiG9w0BAQsF\nAAOCAQEAjcYoK1etfhGmF0AHuOhIBfIDyVTRzS5G010xc9eO++HAk2w4WOSY8G2i\nyAydynrcIfDL+UT8tafFSsSbgVaOMe6ID7MOmVFDN84uspxvharsZBGVyDTafRg/\nFGoG7FdBjxtwtLDJ5G6pHZsdDkeKSlzKc+tXix2dgZMq+679E17AwZ3AOz4IqS6x\nZsx8152MbZr2HXb6M1NBIdfq+Xq3mnxu4788bYlIIhyk+VFdSbmKIcIN+u33KsiV\nTxCyjn8zgmhk4UT+JOIp/CIIWq/1hls9F7Ru6ySS/LKBiPYNC7cBnFLr893VUP+Z\nYVgmYnZGn6Sk4ZbbgLoJ1W2ZUuATyQ==\n-----END CERTIFICATE-----')
  	expect(chef_run).to create_file('/etc/ssl/private/ssl-without-intermediate-cert.com.key').with(content: '-----BEGIN RSA PRIVATE KEY-----\nProc-Type: 4,ENCRYPTED\nDEK-Info: DES-EDE3-CBC,H7F2CE4EA23BE5B4\n\nvee/I75R0Gyfbz4dgQRwcJNGoBZ9YGscj+rvGgH5/5aj8cOSYigUOUq8wLIpMNyy\nv33fSRZ4SHOnGUDMkyChWaCmPHemwr7q688GdQUjqAIz9TSAKTQyXMy5KcGOPr7v\n2XX0I57WdNFHpeqJEeq88g3HLBMjnosiqcoR+9JMEIyzvW9FY5qKk7MAjXmT2NLm\nF1TO1Dt7jZiiW46ROapor/u5/ADblr0h595qAnzdX518cRIjKSeLUxoVp9N22Q+C\nvwHd+RGfg5X6Ml+YG2E9kiukxOxV7/Zg/SzEcV3/2ZVbzbKhWffz858JYZNiFzX6\nN1utO53MkTr6n2t2iGcW3LMkH4lSC/hnwWUuQEf0HR58RmW6OZ/K0+CEf7IMPl+l\nS+FnQSmoksD6KK8w8GBEUUSc4zSx7x0gWo/e8oFhQqocTzkV5AtormiW1nq4GeQD\nRqQwa440z7sHoMAwiUZdfwJf07hFLAPghu/jqlukwxp17wJG6ga1/ah4Xw/3CINr\nIl6TvW5MevFvrd58hz/MsFanJrdSjKC3cnScDdwSTiYEjOecJMXLl+YkyBmtHrzt\nQTL02cIEtj1d6R6xPliKTWwT0DkyiaKi7H51EMzsaRxLgrgjTzzxBjg1zAB+Nf6x\nS/1oY8M/uEUMjXMIpohbIXkLN0JhVVWoubDDFzp2UqSmS2KgtI/48atTzEMOUW4O\nBndVngsmeroeRTuGmkXbYRKQcNWIf8vZAYNeEXklOL5oxWxGmtwj1wGaNYIb52N+\n5CQ9d2CBBp8S1iN22RPHbIy8Nr36ma79qqjKpgVghICOs71+vBZpDfva35ynpwmr\nvcpS+GfR/tJFAB4R9CwNyOlnHmz6JiZ9Wj74Ovgq+yrNeO8dUF0itP1m/KTU8Shi\nrz5Db1G1cd0biNEwAlVsGgxWRtjeP2OgZwRER/4BZnJLQHkxvCRxI4WmjBqJNYC2\ng4zYLyzyA/g6dPu76cjdHDjiX2/onKvw2H6wcAtUFOcGTTZFkwenOkpegj0nhqoo\nF51OGpW1YN7cG/H3/kQ5g23fmXwRTVGqguBT2TIKM8kMCfmsbgEUQ8UgAsYWyFwd\n1RDlg1k+WfFgpGg+7qa+C11A4qXefgk9mAK0vzHTULPCOmSVWp5k3ozkupsQtBbE\nkNZnDpQmwPd15HSRWWrx3AqSOGSLW70co4KMpSiD81yvu/s+15opRVgEdwMBUeaj\ni28Bjj6750J/SCY9xWUxlkYf4gCNJc5cqR4BrGTNedtr0hiWCQq6XZp1ICu1eVdH\nEd5Bt4LY1iwAsnzL0/P/i9uVkAyJuVpMeC1NUPH7ObcH0rYHYhSHTyJf1QvXg7Aj\n1CbjSfS/0G4hvs1hNp9KuAJ0afCUnIc7pW0iwlnm3DEVtIp686q1Aes+2vna0fog\nbLtci0vaOFXWpSCy7Cp/K/VyxGLiyRWfLCYTn7BHPhr5qPnBuhoF1Tta6c6hys7d\n4G3wYnSiOyDnRSnrWz1oFwHxS9y8oFez1e7gtNoL7z70TsyJo8S7IPkRu2V6Ek7x\n42M83ZW5dVFvGF2TyeDhhMnt3OKv4/zjvAMs9wAgxbNI2uFxCkX/8kYprA1Ptw2o\n-----END RSA PRIVATE KEY-----')
  end

  it 'creates directory /websites/example.com/ssl and /websites/ssl-website-wic.com' do
    expect(chef_run).to create_directory('/websites/example.com/ssl').with(owner: 'www-data', group: 'www-data', recursive: true)
    expect(chef_run).to create_directory('/websites/ssl-website-wic.com').with(owner: 'www-data', group: 'www-data', recursive: true)
  end

  describe '/etc/apache2/sites-available/ssl.example.com-ssl.conf' do
    it 'is created' do
      expect(chef_run).to create_template('/etc/apache2/sites-available/ssl.example.com-ssl.conf')
    end

    it 'has vhost ssl.example.com' do
      expect(chef_run).to render_file('/etc/apache2/sites-available/ssl.example.com-ssl.conf').with_content('ServerName ssl.example.com')
    end

    it 'has docroot /websites/example.com/ssl' do
      expect(chef_run).to render_file('/etc/apache2/sites-available/ssl.example.com-ssl.conf').with_content('DocumentRoot /websites/example.com/ssl')
    end

    it 'has serveraliases ssl2.example.com' do
      expect(chef_run).to render_file('/etc/apache2/sites-available/ssl.example.com-ssl.conf').with_content('ServerAlias ssl2.example.com')
    end

    it 'has directory index index.html index.htm index.php' do
      expect(chef_run).to render_file('/etc/apache2/sites-available/ssl.example.com-ssl.conf').with_content('DirectoryIndex index.html index.htm index.php')
    end

    it 'overwrites the Log setting' do
      expect(chef_run).to render_file('/etc/apache2/sites-available/ssl.example.com-ssl.conf').with_content('AllowOverride All')
    end
  end

  describe '/etc/apache2/sites-available/ssl-without-intermediate-cert.com-ssl.conf' do
    it 'is created' do
      expect(chef_run).to create_template('/etc/apache2/sites-available/ssl-without-intermediate-cert.com-ssl.conf')
    end

    it 'has vhost ssl-without-intermediate-cert.com' do
      expect(chef_run).to render_file('/etc/apache2/sites-available/ssl-without-intermediate-cert.com-ssl.conf').with_content('ServerName ssl-without-intermediate-cert.com')
    end

    it 'has docroot /websites/ssl-website-wic.com' do
      expect(chef_run).to render_file('/etc/apache2/sites-available/ssl-without-intermediate-cert.com-ssl.conf').with_content('DocumentRoot /websites/ssl-website-wic.com')
    end

    it 'has directory index index.html index.htm index.php' do
      expect(chef_run).to render_file('/etc/apache2/sites-available/ssl-without-intermediate-cert.com-ssl.conf').with_content('DirectoryIndex index.html index.htm index.php')
    end

    it 'overwrites the Log setting' do
      expect(chef_run).to render_file('/etc/apache2/sites-available/ssl-without-intermediate-cert.com-ssl.conf').with_content('AllowOverride All')
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