$LOAD_PATH.unshift File.join(File.dirname(__FILE__))
require "lib/dotfiles"

desc "Symlinks dotfiles to your user home"
task :default => :symlink

task :symlink do 
  DotFiles.symlink
end
