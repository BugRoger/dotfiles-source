Given /^the shared dotfiles contain a file "([^"]*)"$/ do |file_name|
  FileUtils.touch file_name 
  File.open(file_name, "a").puts(file_name)   
end

Given /^the hostname is "([^"]*)"$/ do |host|
  DotFiles.any_instance.stub(:hostname).and_return(host)
end

Then /^the file "([^"]*)" should not be in my user home$/ do |target|
  File.should_not be_exists(File.expand_path "~/#{target}")
end
