torrentbox Cookbook [![Build Status](https://travis-ci.org/haganenorekenjutsushi/torrentbox.svg?branch=master)](https://travis-ci.org/haganenorekenjutsushi/torrentbox)
===================
Orchestration cookbook for combination MediaCentre/Torrentbox servers in home environment.


Requirements
------------

#### packages
- `apache2` - torrentbox needs apache to display the dashboard
- `sickrage` - torrentbox needs sickrage to organise TV shows
- `couchpotato` - torrentbox needs couchpotato to organise Movies
- `transmission` - torrentbox needs transmission to download torrents
- `snapraid` - torrentbox needs apache to create disk parities
- `mhddfs` - torrentbox needs mhddfs to pool disks
- `cifs-utils` - torrentbox needs cifs to create shares

Attributes
----------


#### torrentbox::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['torrentbox']['dashboard']['path']</tt></td>
    <td>string</td>
    <td>location of dashboard website</td>
    <td><tt>/var/www/html/</tt></td>
  </tr>
   <tr>
    <td><tt>['torrentbox']['dashboard']['repo']</tt></td>
    <td>string</td>
    <td>git url of dashboard python repo</td>
    <td><tt>git://github.com/haganenorekenjutsushi/torrentbox-dashboard.git</tt></td>
  </tr>
  <tr>
    <td><tt>['torrentbox']['cifsshares']</tt></td>
    <td>array</td>
    <td>array of remote cifs shares to mount  (and their local/remote paths)</td>
    <td><tt>null</tt></td>
  </tr>
  <tr>
    <td><tt>['torrentbox']['disks']</tt></td>
    <td>array</td>
    <td>disks and their options</td>
    <td><tt>null</tt></td>
  </tr>
  <tr>
    <td><tt>['torrentbox']['cifscredentials']['user']</tt></td>
    <td>string</td>
    <td>name of the user to populate .smbcredentials with</td>
    <td><tt>downloadmanager</tt></td>
  </tr>
   <tr>
    <td><tt>['torrentbox']['cifscredentials']['password']</tt></td>
    <td>string</td>
    <td>password of the user to populate .smbcredentials with</td>
    <td><tt>P@sswort</tt></td>
  </tr>
</table>

Usage
-----
#### torrentbox::default

```json
{
  "run_list": [
    "recipe[torrentbox]",
    "recipe[torrentbox-sickrage]",
    "recipe[transmission]",
    "recipe[torrentbox-couchpotatoserver]"
  ],
  "torrentbox": {
   
    "disks": [
      {
        "device" : "cb92d746-cb71-491e-8f3a-86eef42ce878",
        "device_type": "uuid",
        "fstype" : "ext4",
        "path" : "/media/Parity1",
        "options" : "defaults"
      }
    ]
  }
}
```

Contributing
------------

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github


