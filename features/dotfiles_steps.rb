Given /^I have a folder containing files and folders$/ do
end

When /^I run the link tool$/ do
  require 'rake'
  Rake.application.run
end

Then /^the files are being linked into my user home$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^the folders are being linked into my user home$/ do
  pending # express the regexp above with the code you wish you had
end

