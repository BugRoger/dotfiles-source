require "rspec"
require "dotfiles"
require "fakefs"

describe "dotfiles" do

  after :each do
    FakeFS::FileSystem.clear
  end

  describe "#symlink" do
    it "should replicate source dir to user home" do
      FileUtils.touch ".vimrc"

      DotFiles.symlink

      File.should exist("~/.vimrc")
    end

    it "should skip existing symlinks" do 
      FileUtils.touch ".vimrc"
      FileUtils.mkdir ".vim"
      File.symlink    ".vim", "~/.vimrc"
      
      DotFiles.symlink

      File.readlink("~/.vimrc").should == ".vim"
    end
  end

  describe "#source_files" do
    it "should glob files from source directory" do
      FileUtils.touch ".vimrc"
      FileUtils.mkdir ".vim"

      DotFiles.source_files.should =~ %w{.vimrc .vim}.map { |f| File.expand_path f }
    end
  end

  describe "#dotify" do
    it "should return the basename only" do
      DotFiles.dotify("/dotfiles/.vimrc").should == ".vimrc"
    end

    context "leading dot missing" do
      it "should add a leading dot" do
        DotFiles.dotify("vimrc").should == ".vimrc"
      end

      it "should add a leading dot for absolute paths" do
        DotFiles.dotify("/dotfiles/vimrc").should == ".vimrc"
      end
    end

    context "leading dot exists" do
      it "should not add a leading dot" do
        DotFiles.dotify(".vimrc").should == ".vimrc"
      end
    end
  end
end
