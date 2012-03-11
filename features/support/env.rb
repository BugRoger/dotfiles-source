require 'rake'
require 'fakefs/safe'

Before('@fakefs') do
  FakeFS.activate!
end

After('@fakefs') do
  FakeFS::FileSystem.clear
  FakeFS.deactivate!
end
