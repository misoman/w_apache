require_relative '../spec_helper'

describe 'w_apache::deploy' do
  context 'with default setting' do

    before do
      stub_command("cat /websites/example.com/.git/config | grep https://git.examplewebsite.com/www.git").and_return(false)
      stub_command("cat /websites/example2.com/.git/config | grep https://git.examplewebsite.com/www2.git").and_return(false)
      stub_command("cat /websites/multi-repo-vhost.com/.git/config | grep https://git.examplewebsite.com/multi-repo-vhost.com-repo1.git").and_return(false)
      stub_command("cat /websites/multi-repo-vhost.com/repo2/.git/config | grep https://git.examplewebsite.com/multi-repo-vhost.com-repo2.git").and_return(false)
      stub_data_bag('w_apache').and_return(['deploykey'])
      stub_data_bag_item("w_apache", "deploykey").and_return('id' => 'deploykey', 'private_key' => '-----BEGIN RSA PRIVATE KEY-----CVIOpAIBAAKCAQEA4tcgfvo5E7HG3u+Bl1zDHmW+L4vbCE31PlCzPnUA+1iLfb6Sv1x/ibzhVsFXALP0LON5lL2/3wf6B+qH7t6JpsmYo8qsWpmKy2J7pygQYrmHsxhxxaVU2NEhZT/uhWLKzF40yJ74/of5yBxwutoESYEl1YIilPiGJaWMmQtFUlCiHa7iZQ0Rx7w+A/waxnslA1cajwb3T4PdmLK5zPd8c+089BiCXzJgrKsGSJQ0Ea/EemoU2LIwvs75P3e6necmMSpjqaZGr9s87orbKq1pNyh3/QWzn4C3OKj8QX1m/g51YkUvzTSJzLeJMZygrhSCEU4KoqmwMWW8yUmLMs2xLQIBIwKCAQEAlREGudeh2b33txJrGlLmnvJnCU1GyvFmpUr5ci+hjzovx6kemwJFLqCxVkSJoWBQAD22S80mULwZVai/ujp3tr795/o2vzGy+q5ug8ne4cpgfQFvVf7unRu23CKyr2zOaQq0+N1/DanQByih2d+5rKVTYGt1z5wAYeHRa+LVyF+ixRjZh8kl0y74V32MpWoLddDjK4t5Kcqp/YRJ+cZrj0sqZhIKotbowhbzPZm4a9s7tqbsgLzTbKZPDLqibA1sxtC0DjfavaVEG79QWw+ReNJpxXLCK6LuoiOlJTheOkkX9OT0Hmt4UKILtQsNxASzwD6omQT1L1zqj/d1G/dutwKBgQD2UbMPrhxyjQktLCM7EUCcQvs7siyPGzdCxCsYy8fLEYnHD+8BIaqbfdmzpcca5US0UluTUHBG89qshKN8GlhGqGoghxrvT9QOMvL4vz/bx5Bc3CWyAaqR0rLoPMIRyJdhxMP2oDNKw6j3dF1s6KyBlH16zGoVyhse8AJTjXhGYwKBgQDrwXHVmmV77jPv+aqEHa9sLncKu/sI3nE/Gxdc9GXsUK5LoeGHUNyPgeYNAkdZk2tcPqEv5b5lRwJaAICVQ03sF2xoyiAVo5xi6mmfypik72MK3iY+UE2Cm7/V7XvQ8wfY5g6OCdgjxgG3k3xLWFW3TSNMfhaq3G9PKrhkC3i3LwKBgQDvSA0H6vcQMTwdQNHEWeb+MnBl4EiLBH7TJPaqX47ihhDQANmMEhNyekEyLAM+stUG8Os+pelpfywyj3o+CvarCgCx4lSt9cautSaLPXE75m77HwAMAZ5hxV1WoWwRRoRtmpJ6jP6gZkxeGUTQMnuxE+eb3IRPrmN9I6p9DRXAtwKBgQCa7NXG4c2pNiIhWuxlcpfZYFzbKxKuDoTu9IuyHPKFWZcbwiZ9fkfMBOeiJhGhQ55Sj45+j6kAuaJ1qI8DAFfHCBQKWPCDP6FIUOZTEBsqjq7MoJzJ3P+8Ona/x/JHeyJp9kQUMlrVrgEg3UMM8Ofe2utPhg7lTwdRR/WDkoKHAQKBgQDeqRjEqLVs8sHu49PeVY2v/JbDhWHLmyCTP7v8tn9UA/E0JATz8/7lEr5nqGoWx7MK4AYv4QUIRH9eamkMA8TZy7gAPCCb13wllU0ntbD7Dtm0RioxGwnD4GeQEBwIQ4BdMl4wbDmPt9rhBEGkD9vGDkmbU4iHoWK8rC0EHrgCsQ+=-----END RSA PRIVATE KEY-----')
      stub_data_bag_item("w_apache", "jenkinskey").and_return('id' => 'jenkinskey', 'public_key' => 'ssh-rsa BAAAB3NzaC1yc2EAAAADAQABAAABAQDFrcjKWXebaCrE49CikRd1ScSuRdbMuJ6aMxBgg9RuA9c2Lzn70YFguoSXl0xwdhxIG4O+ft6lL4TwJy80J+Hs1cUE/GxemLDYSVwfG61+AqDonYnMRvdeYsWxfTi5lINA60IIUkvv5fNS69FLRoJT8sZdUDX9rF/swuEohcVT3GVUyKfGZtEJcASYwSiHXiyJ3tgfFNTeRZKw/qMWX+bSCUbFAJrTyHzg0FobEVWyUdlUvNXnNI8vlhh6qbnx4cPmRWqsqsEPWe3CjDArzgMs3m5ez0+7S3SrBf3mNqbzH0E/RhsrQqOuHHPVOz/aVlcKEOaSqiBTXwPn9xZjS4lF jenkins@jenkins.examplewebsite.com')
      stub_data_bag_item("w_apache", "gitlabkey").and_return('id' => 'gitlabkey', 'public_key' => 'git.examplewebsite.com ssh-rsa VAAAB3NzaC1yc2EAAAADAQABAAABAQDN5u2/w1xQdJQWD+/omBz4iR8ZUvPiRRgk6O6MYy+vmrPr4w+GyMYfhvDylhW+BIil2mHDaY7XdMrJb1FlUoS4a0WxMbpvqffMlVQoYphtHbtqALCfD6s+KKIcE0nuwYU7gaMRHU9LFxdsjVv2wRGrW79b8u22ySLRdkKu9tSSfkeAWUP7CMiMELVEr1su5mTeR7j1oQUnoRA6w5fsFRtu5PHMS8i/-jdTwoG4JYWKbmVxqhzso+qT2rix4duJJ8LEN35wCkCO/nbTlXExEZovvjE7hNPmA5EULLN/jWy2Vuq0blqDKs6eN6+lzMME2iplNIKZdfvXO+e90zdHnJOK')
      stub_command("cat /var/www/.ssh/authorized_keys | grep \"ssh-rsa BAAAB3NzaC1yc2EAAAADAQABAAABAQDFrcjKWXebaCrE49CikRd1ScSuRdbMuJ6aMxBgg9RuA9c2Lzn70YFguoSXl0xwdhxIG4O+ft6lL4TwJy80J+Hs1cUE/GxemLDYSVwfG61+AqDonYnMRvdeYsWxfTi5lINA60IIUkvv5fNS69FLRoJT8sZdUDX9rF/swuEohcVT3GVUyKfGZtEJcASYwSiHXiyJ3tgfFNTeRZKw/qMWX+bSCUbFAJrTyHzg0FobEVWyUdlUvNXnNI8vlhh6qbnx4cPmRWqsqsEPWe3CjDArzgMs3m5ez0+7S3SrBf3mNqbzH0E/RhsrQqOuHHPVOz/aVlcKEOaSqiBTXwPn9xZjS4lF jenkins@jenkins.examplewebsite.com\"").and_return(false)
      stub_command("cat /var/www/.ssh/known_hosts | grep \"git.examplewebsite.com ssh-rsa VAAAB3NzaC1yc2EAAAADAQABAAABAQDN5u2/w1xQdJQWD+/omBz4iR8ZUvPiRRgk6O6MYy+vmrPr4w+GyMYfhvDylhW+BIil2mHDaY7XdMrJb1FlUoS4a0WxMbpvqffMlVQoYphtHbtqALCfD6s+KKIcE0nuwYU7gaMRHU9LFxdsjVv2wRGrW79b8u22ySLRdkKu9tSSfkeAWUP7CMiMELVEr1su5mTeR7j1oQUnoRA6w5fsFRtu5PHMS8i/-jdTwoG4JYWKbmVxqhzso+qT2rix4duJJ8LEN35wCkCO/nbTlXExEZovvjE7hNPmA5EULLN/jWy2Vuq0blqDKs6eN6+lzMME2iplNIKZdfvXO+e90zdHnJOK\"").and_return(false)
    end

    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['w_common']['web_apps'] = web_apps
        node.set['w_apache']['deploy']['enabled'] = true
        node.set['w_memcached']['ips'] = ['127.0.0.1']
      end.converge(described_recipe)
    end

    it 'runs recipe git' do
      expect(chef_run).to include_recipe('git')
    end

    it 'generates /etc/hosts file entry to enable communication btw web and gitlap server' do
      expect(chef_run).to append_hostsfile_entry('9.9.9.9 for example.com').with(ip_address: '9.9.9.9', hostname: 'git.examplewebsite.com', unique: true)
      expect(chef_run).to append_hostsfile_entry('9.9.9.9 for example2.com').with(ip_address: '9.9.9.9', hostname: 'git.examplewebsite.com', unique: true)
    end

    it 'changes shell for www-data' do
      expect(chef_run).to run_execute('sudo chsh -s /bin/sh www-data')
    end

    it 'creates /var/www/.ssh and /var/www/.ssh/id_rsa' do
      expect(chef_run).to create_directory('/var/www/.ssh').with(owner: 'www-data', group: 'www-data', mode: '0700')
      expect(chef_run).to create_file('/var/www/.ssh/id_rsa').with_content('-----BEGIN RSA PRIVATE KEY-----CVIOpAIBAAKCAQEA4tcgfvo5E7HG3u+Bl1zDHmW+L4vbCE31PlCzPnUA+1iLfb6Sv1x/ibzhVsFXALP0LON5lL2/3wf6B+qH7t6JpsmYo8qsWpmKy2J7pygQYrmHsxhxxaVU2NEhZT/uhWLKzF40yJ74/of5yBxwutoESYEl1YIilPiGJaWMmQtFUlCiHa7iZQ0Rx7w+A/waxnslA1cajwb3T4PdmLK5zPd8c+089BiCXzJgrKsGSJQ0Ea/EemoU2LIwvs75P3e6necmMSpjqaZGr9s87orbKq1pNyh3/QWzn4C3OKj8QX1m/g51YkUvzTSJzLeJMZygrhSCEU4KoqmwMWW8yUmLMs2xLQIBIwKCAQEAlREGudeh2b33txJrGlLmnvJnCU1GyvFmpUr5ci+hjzovx6kemwJFLqCxVkSJoWBQAD22S80mULwZVai/ujp3tr795/o2vzGy+q5ug8ne4cpgfQFvVf7unRu23CKyr2zOaQq0+N1/DanQByih2d+5rKVTYGt1z5wAYeHRa+LVyF+ixRjZh8kl0y74V32MpWoLddDjK4t5Kcqp/YRJ+cZrj0sqZhIKotbowhbzPZm4a9s7tqbsgLzTbKZPDLqibA1sxtC0DjfavaVEG79QWw+ReNJpxXLCK6LuoiOlJTheOkkX9OT0Hmt4UKILtQsNxASzwD6omQT1L1zqj/d1G/dutwKBgQD2UbMPrhxyjQktLCM7EUCcQvs7siyPGzdCxCsYy8fLEYnHD+8BIaqbfdmzpcca5US0UluTUHBG89qshKN8GlhGqGoghxrvT9QOMvL4vz/bx5Bc3CWyAaqR0rLoPMIRyJdhxMP2oDNKw6j3dF1s6KyBlH16zGoVyhse8AJTjXhGYwKBgQDrwXHVmmV77jPv+aqEHa9sLncKu/sI3nE/Gxdc9GXsUK5LoeGHUNyPgeYNAkdZk2tcPqEv5b5lRwJaAICVQ03sF2xoyiAVo5xi6mmfypik72MK3iY+UE2Cm7/V7XvQ8wfY5g6OCdgjxgG3k3xLWFW3TSNMfhaq3G9PKrhkC3i3LwKBgQDvSA0H6vcQMTwdQNHEWeb+MnBl4EiLBH7TJPaqX47ihhDQANmMEhNyekEyLAM+stUG8Os+pelpfywyj3o+CvarCgCx4lSt9cautSaLPXE75m77HwAMAZ5hxV1WoWwRRoRtmpJ6jP6gZkxeGUTQMnuxE+eb3IRPrmN9I6p9DRXAtwKBgQCa7NXG4c2pNiIhWuxlcpfZYFzbKxKuDoTu9IuyHPKFWZcbwiZ9fkfMBOeiJhGhQ55Sj45+j6kAuaJ1qI8DAFfHCBQKWPCDP6FIUOZTEBsqjq7MoJzJ3P+8Ona/x/JHeyJp9kQUMlrVrgEg3UMM8Ofe2utPhg7lTwdRR/WDkoKHAQKBgQDeqRjEqLVs8sHu49PeVY2v/JbDhWHLmyCTP7v8tn9UA/E0JATz8/7lEr5nqGoWx7MK4AYv4QUIRH9eamkMA8TZy7gAPCCb13wllU0ntbD7Dtm0RioxGwnD4GeQEBwIQ4BdMl4wbDmPt9rhBEGkD9vGDkmbU4iHoWK8rC0EHrgCsQ+=-----END RSA PRIVATE KEY-----').with(owner: 'www-data', group: 'www-data', mode: '600')
    end

    it 'creates /var/www/.ssh/gitlab_pub and add and delete gitlab_pub' do
      expect(chef_run).to create_file('/var/www/.ssh/gitlab_pub').with(owner: 'www-data', group: 'www-data', content: 'git.examplewebsite.com ssh-rsa VAAAB3NzaC1yc2EAAAADAQABAAABAQDN5u2/w1xQdJQWD+/omBz4iR8ZUvPiRRgk6O6MYy+vmrPr4w+GyMYfhvDylhW+BIil2mHDaY7XdMrJb1FlUoS4a0WxMbpvqffMlVQoYphtHbtqALCfD6s+KKIcE0nuwYU7gaMRHU9LFxdsjVv2wRGrW79b8u22ySLRdkKu9tSSfkeAWUP7CMiMELVEr1su5mTeR7j1oQUnoRA6w5fsFRtu5PHMS8i/-jdTwoG4JYWKbmVxqhzso+qT2rix4duJJ8LEN35wCkCO/nbTlXExEZovvjE7hNPmA5EULLN/jWy2Vuq0blqDKs6eN6+lzMME2iplNIKZdfvXO+e90zdHnJOK')
      expect(chef_run).to run_execute('add and delete gitlab_pub for www-data')
    end

    it 'creates /var/www/.ssh and /var/www/.ssh/jenkins_pub and add and delete jenkins_pub for www-data' do
      expect(chef_run).to create_file('/var/www/.ssh/jenkins_pub').with(owner: 'www-data', group: 'www-data', content: 'ssh-rsa BAAAB3NzaC1yc2EAAAADAQABAAABAQDFrcjKWXebaCrE49CikRd1ScSuRdbMuJ6aMxBgg9RuA9c2Lzn70YFguoSXl0xwdhxIG4O+ft6lL4TwJy80J+Hs1cUE/GxemLDYSVwfG61+AqDonYnMRvdeYsWxfTi5lINA60IIUkvv5fNS69FLRoJT8sZdUDX9rF/swuEohcVT3GVUyKfGZtEJcASYwSiHXiyJ3tgfFNTeRZKw/qMWX+bSCUbFAJrTyHzg0FobEVWyUdlUvNXnNI8vlhh6qbnx4cPmRWqsqsEPWe3CjDArzgMs3m5ez0+7S3SrBf3mNqbzH0E/RhsrQqOuHHPVOz/aVlcKEOaSqiBTXwPn9xZjS4lF jenkins@jenkins.examplewebsite.com')
      expect(chef_run).to run_execute('add and delete jenkins_pub for www-data')
    end

    %w( example.com example2.com multi-repo-vhost.com multi-repo-vhost.com/repo2 ).each do |dir|
      it 'make sure ownership of /websites/example.com' do
        expect(chef_run).to create_directory("make sure ownership and existance of /websites/#{dir}").with(path: "/websites/#{dir}", user: 'www-data', group: 'www-data', recursive: true)
      end
    end

    it 'runs a execute git init for www' do
      expect(chef_run).to run_execute('git init for https://git.examplewebsite.com/www.git').with(cwd: '/websites/example.com', command: 'git init', user: 'www-data', group: 'www-data', creates: '/websites/example.com/.git/HEAD')
      expect(chef_run).to run_execute('git init for https://git.examplewebsite.com/www2.git').with(cwd: '/websites/example2.com', command: 'git init', user: 'www-data', group: 'www-data', creates: '/websites/example2.com/.git/HEAD')
      expect(chef_run).to run_execute('git init for https://git.examplewebsite.com/multi-repo-vhost.com-repo1.git').with(cwd: '/websites/multi-repo-vhost.com', command: 'git init', user: 'www-data', group: 'www-data', creates: '/websites/multi-repo-vhost.com/.git/HEAD')
      expect(chef_run).to run_execute('git init for https://git.examplewebsite.com/multi-repo-vhost.com-repo2.git').with(cwd: '/websites/multi-repo-vhost.com/repo2', command: 'git init', user: 'www-data', group: 'www-data', creates: '/websites/multi-repo-vhost.com/repo2/.git/HEAD')
    end

    it 'runs a execute git remote add origin url for www' do
      expect(chef_run).to run_execute('git remote add origin https://git.examplewebsite.com/www.git').with(cwd: '/websites/example.com', user: 'www-data', group: 'www-data')
      expect(chef_run).to run_execute('git remote add origin https://git.examplewebsite.com/www2.git').with(cwd: '/websites/example2.com', user: 'www-data', group: 'www-data')
      expect(chef_run).to run_execute('git remote add origin https://git.examplewebsite.com/multi-repo-vhost.com-repo1.git').with(cwd: '/websites/multi-repo-vhost.com', user: 'www-data', group: 'www-data')
      expect(chef_run).to run_execute('git remote add origin https://git.examplewebsite.com/multi-repo-vhost.com-repo2.git').with(cwd: '/websites/multi-repo-vhost.com/repo2', user: 'www-data', group: 'www-data')
    end

    it 'do not run a execute git remote add origin url when www repo already exists' do
      stub_command("cat /websites/example.com/.git/config | grep https://git.examplewebsite.com/www.git").and_return(true)
      expect(chef_run).to_not run_execute('git remote add origin https://git.examplewebsite.com/www.git').with(cwd: '/websites/example.com', user: 'www-data', group: 'www-data')
    end
  end

  context 'disable creating hosts file entry for gitlab' do

    before do
      stub_command("cat /websites/example.com/.git/config | grep https://git.examplewebsite.com/www.git").and_return(false)
      stub_command("cat /websites/example2.com/.git/config | grep https://git.examplewebsite.com/www2.git").and_return(false)
      stub_command("cat /websites/multi-repo-vhost.com/.git/config | grep https://git.examplewebsite.com/multi-repo-vhost.com-repo1.git").and_return(false)
      stub_command("cat /websites/multi-repo-vhost.com/repo2/.git/config | grep https://git.examplewebsite.com/multi-repo-vhost.com-repo2.git").and_return(false)
      stub_data_bag('w_apache').and_return(['deploykey'])
      stub_data_bag_item("w_apache", "deploykey").and_return('id' => 'deploykey', 'private_key' => '-----BEGIN RSA PRIVATE KEY-----CVIOpAIBAAKCAQEA4tcgfvo5E7HG3u+Bl1zDHmW+L4vbCE31PlCzPnUA+1iLfb6Sv1x/ibzhVsFXALP0LON5lL2/3wf6B+qH7t6JpsmYo8qsWpmKy2J7pygQYrmHsxhxxaVU2NEhZT/uhWLKzF40yJ74/of5yBxwutoESYEl1YIilPiGJaWMmQtFUlCiHa7iZQ0Rx7w+A/waxnslA1cajwb3T4PdmLK5zPd8c+089BiCXzJgrKsGSJQ0Ea/EemoU2LIwvs75P3e6necmMSpjqaZGr9s87orbKq1pNyh3/QWzn4C3OKj8QX1m/g51YkUvzTSJzLeJMZygrhSCEU4KoqmwMWW8yUmLMs2xLQIBIwKCAQEAlREGudeh2b33txJrGlLmnvJnCU1GyvFmpUr5ci+hjzovx6kemwJFLqCxVkSJoWBQAD22S80mULwZVai/ujp3tr795/o2vzGy+q5ug8ne4cpgfQFvVf7unRu23CKyr2zOaQq0+N1/DanQByih2d+5rKVTYGt1z5wAYeHRa+LVyF+ixRjZh8kl0y74V32MpWoLddDjK4t5Kcqp/YRJ+cZrj0sqZhIKotbowhbzPZm4a9s7tqbsgLzTbKZPDLqibA1sxtC0DjfavaVEG79QWw+ReNJpxXLCK6LuoiOlJTheOkkX9OT0Hmt4UKILtQsNxASzwD6omQT1L1zqj/d1G/dutwKBgQD2UbMPrhxyjQktLCM7EUCcQvs7siyPGzdCxCsYy8fLEYnHD+8BIaqbfdmzpcca5US0UluTUHBG89qshKN8GlhGqGoghxrvT9QOMvL4vz/bx5Bc3CWyAaqR0rLoPMIRyJdhxMP2oDNKw6j3dF1s6KyBlH16zGoVyhse8AJTjXhGYwKBgQDrwXHVmmV77jPv+aqEHa9sLncKu/sI3nE/Gxdc9GXsUK5LoeGHUNyPgeYNAkdZk2tcPqEv5b5lRwJaAICVQ03sF2xoyiAVo5xi6mmfypik72MK3iY+UE2Cm7/V7XvQ8wfY5g6OCdgjxgG3k3xLWFW3TSNMfhaq3G9PKrhkC3i3LwKBgQDvSA0H6vcQMTwdQNHEWeb+MnBl4EiLBH7TJPaqX47ihhDQANmMEhNyekEyLAM+stUG8Os+pelpfywyj3o+CvarCgCx4lSt9cautSaLPXE75m77HwAMAZ5hxV1WoWwRRoRtmpJ6jP6gZkxeGUTQMnuxE+eb3IRPrmN9I6p9DRXAtwKBgQCa7NXG4c2pNiIhWuxlcpfZYFzbKxKuDoTu9IuyHPKFWZcbwiZ9fkfMBOeiJhGhQ55Sj45+j6kAuaJ1qI8DAFfHCBQKWPCDP6FIUOZTEBsqjq7MoJzJ3P+8Ona/x/JHeyJp9kQUMlrVrgEg3UMM8Ofe2utPhg7lTwdRR/WDkoKHAQKBgQDeqRjEqLVs8sHu49PeVY2v/JbDhWHLmyCTP7v8tn9UA/E0JATz8/7lEr5nqGoWx7MK4AYv4QUIRH9eamkMA8TZy7gAPCCb13wllU0ntbD7Dtm0RioxGwnD4GeQEBwIQ4BdMl4wbDmPt9rhBEGkD9vGDkmbU4iHoWK8rC0EHrgCsQ+=-----END RSA PRIVATE KEY-----')
      stub_data_bag_item("w_apache", "jenkinskey").and_return('id' => 'jenkinskey', 'public_key' => 'ssh-rsa BAAAB3NzaC1yc2EAAAADAQABAAABAQDFrcjKWXebaCrE49CikRd1ScSuRdbMuJ6aMxBgg9RuA9c2Lzn70YFguoSXl0xwdhxIG4O+ft6lL4TwJy80J+Hs1cUE/GxemLDYSVwfG61+AqDonYnMRvdeYsWxfTi5lINA60IIUkvv5fNS69FLRoJT8sZdUDX9rF/swuEohcVT3GVUyKfGZtEJcASYwSiHXiyJ3tgfFNTeRZKw/qMWX+bSCUbFAJrTyHzg0FobEVWyUdlUvNXnNI8vlhh6qbnx4cPmRWqsqsEPWe3CjDArzgMs3m5ez0+7S3SrBf3mNqbzH0E/RhsrQqOuHHPVOz/aVlcKEOaSqiBTXwPn9xZjS4lF jenkins@jenkins.examplewebsite.com')
      stub_data_bag_item("w_apache", "gitlabkey").and_return('id' => 'gitlabkey', 'public_key' => 'git.examplewebsite.com ssh-rsa VAAAB3NzaC1yc2EAAAADAQABAAABAQDN5u2/w1xQdJQWD+/omBz4iR8ZUvPiRRgk6O6MYy+vmrPr4w+GyMYfhvDylhW+BIil2mHDaY7XdMrJb1FlUoS4a0WxMbpvqffMlVQoYphtHbtqALCfD6s+KKIcE0nuwYU7gaMRHU9LFxdsjVv2wRGrW79b8u22ySLRdkKu9tSSfkeAWUP7CMiMELVEr1su5mTeR7j1oQUnoRA6w5fsFRtu5PHMS8i/-jdTwoG4JYWKbmVxqhzso+qT2rix4duJJ8LEN35wCkCO/nbTlXExEZovvjE7hNPmA5EULLN/jWy2Vuq0blqDKs6eN6+lzMME2iplNIKZdfvXO+e90zdHnJOK')
      stub_command("cat /var/www/.ssh/authorized_keys | grep \"ssh-rsa BAAAB3NzaC1yc2EAAAADAQABAAABAQDFrcjKWXebaCrE49CikRd1ScSuRdbMuJ6aMxBgg9RuA9c2Lzn70YFguoSXl0xwdhxIG4O+ft6lL4TwJy80J+Hs1cUE/GxemLDYSVwfG61+AqDonYnMRvdeYsWxfTi5lINA60IIUkvv5fNS69FLRoJT8sZdUDX9rF/swuEohcVT3GVUyKfGZtEJcASYwSiHXiyJ3tgfFNTeRZKw/qMWX+bSCUbFAJrTyHzg0FobEVWyUdlUvNXnNI8vlhh6qbnx4cPmRWqsqsEPWe3CjDArzgMs3m5ez0+7S3SrBf3mNqbzH0E/RhsrQqOuHHPVOz/aVlcKEOaSqiBTXwPn9xZjS4lF jenkins@jenkins.examplewebsite.com\"").and_return(false)
      stub_command("cat /var/www/.ssh/known_hosts | grep \"git.examplewebsite.com ssh-rsa VAAAB3NzaC1yc2EAAAADAQABAAABAQDN5u2/w1xQdJQWD+/omBz4iR8ZUvPiRRgk6O6MYy+vmrPr4w+GyMYfhvDylhW+BIil2mHDaY7XdMrJb1FlUoS4a0WxMbpvqffMlVQoYphtHbtqALCfD6s+KKIcE0nuwYU7gaMRHU9LFxdsjVv2wRGrW79b8u22ySLRdkKu9tSSfkeAWUP7CMiMELVEr1su5mTeR7j1oQUnoRA6w5fsFRtu5PHMS8i/-jdTwoG4JYWKbmVxqhzso+qT2rix4duJJ8LEN35wCkCO/nbTlXExEZovvjE7hNPmA5EULLN/jWy2Vuq0blqDKs6eN6+lzMME2iplNIKZdfvXO+e90zdHnJOK\"").and_return(false)
    end

    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['w_common']['web_apps'] = web_apps
        node.set['w_apache']['deploy']['enabled'] = true
        node.set['w_apache']['deploy']['enable_repo_hostsfile'] = false
        node.set['w_memcached']['ips'] = ['127.0.0.1']
      end.converge(described_recipe)
    end

    it 'will not generates /etc/hosts file entry to enable communication btw web and gitlap server' do
      expect(chef_run).not_to append_hostsfile_entry('9.9.9.9 for example.com').with(ip_address: '9.9.9.9', hostname: 'git.examplewebsite.com', unique: true)
      expect(chef_run).not_to append_hostsfile_entry('9.9.9.9 for example2.com').with(ip_address: '9.9.9.9', hostname: 'git.examplewebsite.com', unique: true)
    end
  end
end
