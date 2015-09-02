# Install Docker
include_recipe 'docker::default'

# Create directories
[
  node['torrentbox']['directories']['tv_downloads'], node['torrentbox']['directories']['movie_downloads'],
  node['torrentbox']['directories']['incomplete_downloads'],
  node['torrentbox']['directories']['tv'], node['torrentbox']['directories']['movies'],
  '/opt/CouchPotato', '/opt/SickRage', '/opt/plex/Library/Application Support/Plex Media Server/', '/opt/transmission'
].each do |share|
  directory share do
    owner 'root'
    action :create
    recursive true
    mode '0755'
  end
end

# Default transmission settings
cookbook_file 'settings.json' do
  path '/opt/transmission/settings.json'
  mode '0755'
  action :create_if_missing
end

# Default Plex settings
cookbook_file 'Preferences.xml' do
  path "/opt/plex/Library/Application\ Support/Plex\ Media\ Server/Preferences.xml"
  mode '0755'
  action :create_if_missing
end

# Default Couchpotato settings
cookbook_file 'CouchPotato.cfg' do
  path '/opt/CouchPotato/CouchPotato.cfg'
  mode '0755'
  action :create_if_missing
end

# Default SickRage settings
cookbook_file 'config.ini' do
  path '/opt/SickRage/config.ini'
  mode '0755'
  action :create_if_missing
end

# Pull latest image
docker_image 'haganenorekenjutsushi/sickrage' do
  source 'github.com/haganenorekenjutsushi/sickrage-docker'
  action :build_if_missing
end
# Pull latest image
docker_image 'timhaak/transmission' do
  cmd_timeout 900
  action :pull_if_missing
end
# Pull latest image
docker_image 'timhaak/couchpotato' do
  cmd_timeout 900
  action :pull_if_missing
end
# Pull latest image
docker_image 'timhaak/plex' do
  cmd_timeout 900
  action :pull_if_missing
end

# Install Transmission
docker_container 'dperson/transmission' do
  container_name 'transmission'
  detach true
  cmd_timeout 900
  port %w('9091:9091' '45555:45555' '51415:51415' '51415:51415/udp')
  env %w('TRUSER=username' 'TRPASSWD=password')
  volume %W('/opt/transmission:/config'
            "#{node['torrentbox']['directories']['tv_downloads'].gsub ' ', '\\ '}:/tv_downloads"
            "#{node['torrentbox']['directories']['movie_downloads'].gsub ' ', '\\ '}:/movie_downloads"
            "#{node['torrentbox']['directories']['incomplete_downloads'].gsub ' ', '\\ '}:/var/lib/transmission-daemon/incomplete"
            "/opt/transmission:/var/lib/transmission-daemon/info"
            '/etc/localtime:/etc/localtime:ro')
end

# Install SickRage
docker_container 'haganenorekenjutsushi/sickrage' do
  container_name 'sickrage'
  detach true
  port '8081:8081'
  link 'transmission:transmission'
  volume %W('/opt/SickRage/:/config'
            "#{node['torrentbox']['directories']['tv_downloads'].gsub ' ', '\\ '}:/downloads"
            "#{node['torrentbox']['directories']['tv_downloads'].gsub ' ', '\\ '}:/tv_downloads"
            "#{node['torrentbox']['directories']['tv'].gsub ' ', '\\ '}:/tv"
            '/etc/localtime:/etc/localtime:ro')
end

# Install CouchPotato
docker_container 'timhaak/couchpotato' do
  container_name 'couchpotato'
  detach true
  port '5050:5050'
  link 'transmission:transmission'
  volume %W('/opt/CouchPotato:/config'
            "#{node['torrentbox']['directories']['movie_downloads'].gsub ' ', '\\ '}:/movie_downloads"
            "#{node['torrentbox']['directories']['movies'].gsub ' ', '\\ '}:/movies"
            '/etc/localtime:/etc/localtime:ro')
end

# Install Plex
docker_container 'timhaak/plex' do
  container_name 'plex'
  detach true
  port '32400:32400'
  volume %W('/opt/plex:/config'
            "#{node['torrentbox']['directories']['tv'].gsub ' ', '\\ '}:/tv"
            "#{node['torrentbox']['directories']['movies'].gsub ' ', '\\ '}:/movies"
            '/etc/localtime:/etc/localtime:ro')
end
