default['torrentbox'] = {
  'repo' => 'https://github.com/SickragePVR/SickRage',
  'dashboard' => {
    'path' => '/var/www/html/',
    'repo' => 'git://github.com/haganenorekenjutsushi/torrentbox-dashboard.git',
    'diskUsagePath' => '/'
  },

  'disks' => [

  ],
  'mhddfs' => {
    'source_disks' => ['/media/disk1', '/media/disk2'],
    'mount_point' => '/mnt/virtual'
  },
  'directories' => {
    'tv_downloads' => '/mnt/virtual/downloads/tv',
    'movie_downloads' => '/mnt/virtual/downloads/movies',
    'incomplete_downloads' => '/mnt/virtual/downloads/incomplete',
    'tv' => '/mnt/virtual/tv',
    'movies' => '/mnt/virtual/movies'
  }

}
