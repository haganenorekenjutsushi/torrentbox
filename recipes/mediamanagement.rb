# Install Docker
docker_installation 'default' do
  repo 'main'
  action :create
end

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
    mode '0777'
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
docker_image 'linuxserver/plex' do
  write_timeout 900
  read_timeout 900
  action :pull
end

# Pull latest image
docker_image 'linuxserver/sickrage' do
  write_timeout 900
  read_timeout 900
  action :pull
end
# Pull latest image
docker_image 'dperson/transmission' do
  write_timeout 900
  read_timeout 900
  action :pull
end
# Pull latest image
docker_image 'timhaak/couchpotato' do
  write_timeout 900
  read_timeout 900
  action :pull
end


# Install Transmission
docker_container 'transmission' do
  repo 'dperson/transmission'
  detach true
  write_timeout 900
  read_timeout 900
  port ['9091:9091', '45555:45555', '51415:51415', '51415:51415/udp']
  env %w('TRUSER=username' 'TRPASSWD=password')
  binds [
    '/opt/transmission:/config',
    "#{node['torrentbox']['directories']['tv_downloads'] }:/tv_downloads",
    "#{node['torrentbox']['directories']['movie_downloads'] }:/movie_downloads",
    "#{node['torrentbox']['directories']['incomplete_downloads'] }:/var/lib/transmission-daemon/incomplete",
    "#{node['torrentbox']['directories']['tv_downloads'] }:/var/lib/transmission-daemon/downloads",
    "/opt/transmission:/var/lib/transmission-daemon/info",
    '/etc/localtime:/etc/localtime:ro'
  ]
  action [:run_if_missing]
end

# Install SickRage
docker_container 'sickrage' do
  repo 'linuxserver/sickrage'
  write_timeout 900
  read_timeout 900
  detach true
  port '8081:8081'
  links ['transmission:transmission']
  binds [
    '/opt/SickRage/:/config',
    "#{node['torrentbox']['directories']['tv_downloads'] }:/downloads",
    "#{node['torrentbox']['directories']['tv_downloads'] }:/tv_downloads",
    "#{node['torrentbox']['directories']['tv'] }:/tv",
    '/etc/localtime:/etc/localtime:ro'
  ]
end

# Install CouchPotato
docker_container 'couchpotato' do
  repo 'timhaak/couchpotato'
  write_timeout 900
  read_timeout 1800
  detach true
  port '5050:5050'
  links ['transmission:transmission']
  binds [
    '/opt/CouchPotato:/config',
    "#{node['torrentbox']['directories']['movie_downloads'] }:/movie_downloads",
    "#{node['torrentbox']['directories']['movies'] }:/movies",
    '/etc/localtime:/etc/localtime:ro'
  ]
end

# Install Plex
docker_container 'plex' do
  repo 'linuxserver/plex'
  write_timeout 900
  read_timeout 900
  network_mode 'host'
  detach true
  port '32400:32400'
  env %w('PUID=root' 'PGID=root')
  binds [
    '/opt/plex:/config',
    "#{node['torrentbox']['directories']['tv'] }:/data/tvshows",
    "#{node['torrentbox']['directories']['movies'] }:/data/movies",
    '/etc/localtime:/etc/localtime:ro'
  ]
end
