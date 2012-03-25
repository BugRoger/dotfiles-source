Given /^I have a new machine$/ do
  # wheee. new machine <3:-)
end

Given /^I have a folder containing shared dotfiles$/ do
  %w(.vim .tmux).each        { |d| FileUtils.mkdir d }
  %w{.gitconfig .vimrc}.each { |f| FileUtils.touch f }
end

Then /^the dotfiles should be in my user home$/ do
  %w{~/.gitconfig ~/.vimrc ~/.vim ~/.tmux}.each do |target|
    File.should be_exists(File.expand_path target)
  end
end

When /^I run the link tool$/ do
  FakeFS.deactivate!
  Rake.application = Rake::Application.new
  Rake.application.init
  Rake.application.load_rakefile
  FakeFS.activate!

  Rake.application.top_level
end

Given /^there are files without leading dot$/ do
  FileUtils.touch "gemrc"
  FileUtils.mkdir "gem"
end

Then /^all files are prefixed with a dot$/ do
  %w{~/.gemrc ~/.gem}.each do |target|
    File.should be_exists(File.expand_path target)
  end
end

Given /^I have run the link tool$/ do
  step "I have a folder containing shared dotfiles"
  step "I run the link tool"
end

When /^I change a dotfile in my user home$/ do
  File.open("~/.vimrc", "a").puts("Nanananananananana - Batman!")   
end

Then /^it should also change in the shared folder$/ do
  File.read(".vimrc").should be_eql File.read("~/.vimrc")
end

When /^I change a dotfile in the shared folder$/ do
  File.open(".vimrc", "a").puts("Nanananananananana - Robin!")   
end

Then /^it should also change in my user home$/ do
  step "it should also change in the shared folder"
end

