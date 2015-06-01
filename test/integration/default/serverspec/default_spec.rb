require 'spec_helper'

describe port(80) do
  it { should be_listening }
end

describe file('/var/www/html/index.py') do
  it { should be_file }
  it { should be_executable }
end

describe service('apache2') do
  it { should be_enabled   }
  it { should be_running   }
end

describe service('docker') do
  it { should be_enabled   }
  it { should be_running   }
end

# SickRage
describe port(8081) do
  it { should be_listening }
end

# Couchpotato
describe port(5050) do
  it { should be_listening }
end

# File sharing
describe port(445) do
  it { should be_listening }
end

# Plex
describe port(32_400) do
  it { should be_listening }
end

# Transmission
describe port(9091) do
  it { should be_listening }
end

# Check packages installed
%w(python).each do |package|
  describe package(package) do
    it { should be_installed }
  end
end
