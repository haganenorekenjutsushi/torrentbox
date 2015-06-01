source 'https://rubygems.org'

gem 'berkshelf'

group :test do
  gem 'rake'
  gem 'rubocop'
  gem 'codeclimate-test-reporter'
end

group :development do
  gem 'test-kitchen'
  gem 'kitchen-vagrant'
  gem 'guard'
  gem 'guard-kitchen'
  gem 'guard-foodcritic', '>= 1.0'
  gem 'guard-rspec', '>= 4.2'
  gem 'foodcritic', '>= 3.0'
  gem 'chefspec', '>= 3.1'
  gem 'wdm', '>= 0.1.0' if Gem.win_platform?
end
