include_recipe 'git'

private_key = data_bag_item('w_apache', 'deploykey')['private_key']
gitlab_pub = data_bag_item('w_apache', 'gitlabkey')['public_key']
jenkins_pub = data_bag_item('w_apache', 'jenkinskey')['public_key']

execute 'changes shell for www-data' do
  command 'sudo chsh -s /bin/sh www-data'
end

directory "/var/www/.ssh" do
  owner 'www-data'
  group 'www-data'
  mode '0700'
  action :create
end

file '/var/www/.ssh/id_rsa' do
  content private_key
  owner 'www-data'
  group 'www-data'
  mode '600'
end

file '/var/www/.ssh/gitlab_pub' do
  content gitlab_pub
  owner 'www-data'
  group 'www-data'
end

file '/var/www/.ssh/jenkins_pub' do
  content jenkins_pub
  owner 'www-data'
  group 'www-data'
end

execute 'add and delete gitlab_pub for www-data' do
  command 'cat /var/www/.ssh/gitlab_pub >> /var/www/.ssh/known_hosts && rm /var/www/.ssh/gitlab_pub'
  not_if "cat /var/www/.ssh/known_hosts | grep \"#{gitlab_pub}\""
end

execute 'add and delete jenkins_pub for www-data' do
  command 'cat /var/www/.ssh/jenkins_pub >> /var/www/.ssh/authorized_keys && rm /var/www/.ssh/jenkins_pub && chown -R www-data.www-data /var/www/.ssh'
  not_if "cat /var/www/.ssh/authorized_keys | grep \"#{jenkins_pub}\""
end

node['w_common']['web_apps'].each do |web_app|

  next unless web_app.has_key?('deploy')

  if web_app['deploy'].instance_of?(Chef::Node::ImmutableArray) then
    repos = web_app['deploy']
  else
    repos = []
    repos << web_app['deploy']
  end

  repos.each do |repo|

    if repo.has_key?('repo_ip') then

      repo_ip = repo['repo_ip']
      repo_domain = repo['repo_domain']

      hostsfile_entry "#{repo_ip} for #{web_app['vhost']['main_domain']}" do
        ip_address repo_ip
        hostname repo_domain
        action :append
        unique true
      end
    end

    dir = repo['repo_path']
    url = repo['repo_url']

    execute "make sure ownership of #{dir}" do
      command "chown -R www-data.www-data #{dir}"
    end

    execute "git init for #{url}" do
      cwd dir
      command 'git init'
      user 'www-data'
      group 'www-data'
      creates "#{dir}/.git/HEAD"
    end

    execute "git remote add origin #{url}" do
      cwd dir
      user 'www-data'
      group 'www-data'
      not_if "cat #{dir}/.git/config | grep #{url}"
    end
  end
end
