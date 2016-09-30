include_recipe 'git'

private_key = data_bag_item('w_apache', 'deploykey')['private_key']
gitlab_pub = data_bag_item('w_apache', 'gitlabkey')['public_key']
jenkins_pub = data_bag_item('w_apache', 'jenkinskey')['public_key']

execute 'changes shell for user' do
  command "sudo chsh -s /bin/sh #{node['w_apache']['owner']}"
end

directory "#{node['w_apache']['home']}/.ssh" do
  owner node['w_apache']['owner']
  group node['w_apache']['group']
  mode '0700'
  action :create
end

file "#{node['w_apache']['home']}/.ssh/id_rsa" do
  content private_key
  owner node['w_apache']['owner']
  group node['w_apache']['group']
  mode '600'
end

file "#{node['w_apache']['home']}/.ssh/gitlab_pub" do
  content gitlab_pub
  owner node['w_apache']['owner']
  group node['w_apache']['group']
end

file "#{node['w_apache']['home']}/.ssh/jenkins_pub" do
  content jenkins_pub
  owner node['w_apache']['owner']
  group node['w_apache']['group']
end

execute 'add and delete gitlab_pub for user' do
  command "cat #{node['w_apache']['home']}/.ssh/gitlab_pub >> #{node['w_apache']['home']}/.ssh/known_hosts && rm #{node['w_apache']['home']}/.ssh/gitlab_pub"
  not_if "cat #{node['w_apache']['home']}/.ssh/known_hosts | grep \"#{gitlab_pub}\""
end

execute 'add and delete jenkins_pub for user' do
  command "cat #{node['w_apache']['home']}/.ssh/jenkins_pub >> #{node['w_apache']['home']}/.ssh/authorized_keys && rm #{node['w_apache']['home']}/.ssh/jenkins_pub && chown -R #{node['w_apache']['owner']}.#{node['w_apache']['group']} #{node['w_apache']['home']}/.ssh"
  not_if "cat #{node['w_apache']['home']}/.ssh/authorized_keys | grep \"#{jenkins_pub}\""
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
        only_if { node['w_apache']['deploy']['enable_repo_hostsfile'] }
      end
    end

    dir = repo['repo_path']
    url = repo['repo_url']

    directory "make sure ownership and existance of #{dir}" do
      path dir
      owner node['w_apache']['owner']
      group node['w_apache']['group']
      recursive true
    end

    if repo.has_key?('checkout_ref') then

      git dir do
        repository url
        revision repo['checkout_ref']
        enable_checkout false
        user node['w_apache']['owner']
        group node['w_apache']['group']
        action :checkout
      end
    else

      execute "git init for #{url}" do
        cwd dir
        command 'git init'
        user node['w_apache']['owner']
        group node['w_apache']['group']
        creates "#{dir}/.git/HEAD"
      end

      execute "git remote add origin #{url}" do
        cwd dir
        user node['w_apache']['owner']
        group node['w_apache']['group']
        not_if "cat #{dir}/.git/config | grep #{url}"
      end
    end
  end
end
