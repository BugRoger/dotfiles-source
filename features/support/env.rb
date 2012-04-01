require 'rake'
require 'fakefs/safe'
require 'cucumber/rspec/doubles'

Before('@fakefs') do
  FakeFS.activate!
end

After('@fakefs') do
  FakeFS::FileSystem.clear
  FakeFS.deactivate!
end
