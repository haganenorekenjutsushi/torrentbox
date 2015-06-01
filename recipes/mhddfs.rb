# Install mhddfs
package 'mhddfs'

directory node['torrentbox']['mhddfs']['mount_point'] do
  owner 'root'
  action :create
end

# Mount mhddfs virtual directory
source_disks_comma = node['torrentbox']['mhddfs']['source_disks'].join(',')
source_disks_semicolon = node['torrentbox']['mhddfs']['source_disks'].join(';')

execute 'mount mhddfs virtual directory' do
  command <<-EOH
  sudo mhddfs -s #{source_disks_comma} #{node['torrentbox']['mhddfs']['mount_point']} -o allow_other,nonempty
  EOH
  # Don't try to mount the disks to the virtual directory if they're already mounted
  not_if "grep \"#{source_disks_semicolon} #{node['torrentbox']['mhddfs']['mount_point']}\" /etc/mtab"
end
