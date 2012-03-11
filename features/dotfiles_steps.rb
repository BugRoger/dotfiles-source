Given /^I have a new machine$/ do
end

Given /^I have a folder containing shared dotfiles$/ do
  files = %w{gitconfig vimrc}
  dirs  = %w(vim tmux)
  @source_files = files + dirs 

  dirs.each  { |d| FileUtils.mkdir d }
  files.each { |f| FileUtils.touch f }
end

Then /^the dotfiles should be in my user home$/ do
  @source_files.each do |source_file|
    source_path = File.expand_path(source_file)
    target_path = File.expand_path(File.join(ENV['HOME'], source_file))

    File.should be_exists(target_path)
  end
end

When /^I run the link tool$/ do
  FakeFS.deactivate!
  Rake.application.init
  Rake.application.load_rakefile
  FakeFS.activate!

  Rake.application.top_level
end

Given /^there are files without leading dot$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^all files are prefixed with a dot$/ do
  pending # express the regexp above with the code you wish you had
end

