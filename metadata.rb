name 'torrentbox'
maintainer 'haganenorekenjutsushi'
maintainer_email 'haganenorekenjutsushi@gmail.com'
license 'Apache 2.0'
description 'Installs/Configures torrentbox'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.1.1'

depends 'apache2'
depends 'git'
depends 'python'
depends 'apt'
depends 'docker', '~> 2.0'
depends 'samba'
