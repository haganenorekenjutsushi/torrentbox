
# Prevent "unable to execute 'x86_64-linux-gnu-gcc': No such file or directory" error when installing Python packages
package 'build-essential' do
  action :install
end

# Install Python
include_recipe 'python::default'

# Install Apache2
include_recipe 'apache2::default'
include_recipe 'apache2::mod_cgid'

# Install required python modules
python_pip 'psutil'

# Configure default website
web_app '001-default' do
  template 'dashboard-site.conf.erb'
  server_name '*'
  cookbook 'torrentbox'
end

# Delete the default page so we can cleanly bring the dashboard in
file "#{node['torrentbox']['dashboard']['path']}/index.html" do
  action :delete
end

# Control the dashboard dir
directory node['torrentbox']['dashboard']['path'] do
  mode '0755'
  action :create
end

log 'Deploying dashboard'
git node['torrentbox']['dashboard']['path'] do
  repository node['torrentbox']['dashboard']['repo']
  notifies :restart, 'service[apache2]', :delayed
end

# Configure the dashboard
template "#{node['torrentbox']['dashboard']['path']}/config.py" do
  source 'dashboard.py.erb'
  variables(
    diskUsagePath: node['torrentbox']['dashboard']['diskUsagePath']
  )
  mode '777'
  action :create
end

# Ensure we can execute the dashboard's index page
file "#{node['torrentbox']['dashboard']['path']}/index.py" do
  mode '777'
end
