require "rspec"
require 'rspec/mocks/standalone'
require "dotfiles"
require "fakefs"

describe "dotfiles" do

  before(:all) do
    DotFiles.stub(:puts)
  end

  after(:each) do
    FakeFS::FileSystem.clear
  end

  let(:dot_files) { DotFiles.new }
  
  describe "#symlink" do
    it "should replicate source dir to user home" do
      FileUtils.touch ".vimrc"

      dot_files.symlink

      File.should exist("~/.vimrc")
    end

    it "should skip existing symlinks" do 
      FileUtils.touch ".vimrc"
      FileUtils.mkdir ".vim"
      File.symlink    ".vim", "~/.vimrc"
      
      dot_files.symlink

      File.readlink("~/.vimrc").should == ".vim"
    end
  end

  describe "#defaults" do
    it "should glob files" do
      FileUtils.touch "vimrc"
      FileUtils.touch ".gemrc"
      dot_files.defaults.should =~ %w{vimrc .gemrc}
    end

    it "should glob folders" do
      FileUtils.mkdir "vim"
      FileUtils.mkdir ".gem"
      dot_files.defaults.should =~ %w{vim .gem}
    end

    it "should not glob host specific files" do
      FileUtils.touch "vimrc.host-work"
      dot_files.defaults.should be_empty 
    end

    it "should not glob host specific folder" do
      FileUtils.mkdir "vim.host-work"
      dot_files.defaults.should be_empty 
    end

    it "should not glob blacklisted files" do
      dot_files.stub(:blacklist).and_return(%w{batman.txt})
      FileUtils.touch "batman.txt"
      dot_files.defaults.should be_empty
    end
  end

  describe "#host_specific" do
    before(:each) do
      dot_files.stub(:hostname).and_return("work")
    end

    it "should glob host specific files" do
      FileUtils.touch "vimrc.host-work"
      dot_files.host_specific.should =~ %w{vimrc.host-work}
    end

    it "should not glob non-matching host specific files" do
      FileUtils.touch "vimrc.host-home"
      dot_files.host_specific.should be_empty 
    end

    it "should not glob blacklisted files" do
      dot_files.stub(:blacklist).and_return(%w{batman.host-work})
      FileUtils.touch "batman.host-work"
      dot_files.host_specific.should be_empty 
    end
  end

  describe "#merged" do
    before(:each) do
      dot_files.stub(:hostname).and_return("work")
      dot_files.stub(:defaults).and_return(%w{vimrc})
    end

    it "should return defaults and host specific files" do
      dot_files.stub(:host_specific).and_return(%w{gemrc.host-work})
      dot_files.merged.should =~ %w{vimrc gemrc.host-work}
    end

    it "should remove defaults if a more specific file exists" do
      dot_files.stub(:host_specific).and_return(%w{vimrc.host-work})
      dot_files.merged.should =~ %w{vimrc.host-work}
    end
  end

  describe "#targetify" do
    context "leading dot missing" do
      it "should add a leading dot" do
        dot_files.targetify("vimrc").should == "~/.vimrc"
      end
    end

    context "leading dot exists" do
      it "should not add a leading dot" do
        dot_files.targetify(".vimrc").should == "~/.vimrc"
      end
    end

    context "host specific" do
      it "should remove host suffixes" do
        dot_files.stub(:hostname).and_return("work")
        dot_files.targetify("vimrc.host-work").should == "~/.vimrc"
      end
    end
  end

  describe "#hostname" do
    it "should return the hostname" do
      dot_files.should_receive(:`).and_return("work")
      dot_files.hostname.should == "work"
    end

    it "should return the hostname without any domain information" do
      dot_files.should_receive(:`).and_return("work.local")
      dot_files.hostname.should == "work"
    end
  end
end
