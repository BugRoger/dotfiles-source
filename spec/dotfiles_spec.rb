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

    context "hostname matches suffix" do
      before :each do
        DotFiles.stub(:hostname).and_return("work")
      end

      context "default exists" do 
        before :each do
          FileUtils.touch "vimrc"
          FileUtils.touch "vimrc.host-work"
        end

        it "should return the specific file" do
          DotFiles.source_files.should include(File.expand_path "vimrc.host-work")
        end

        it "should not return the default file" do
          DotFiles.source_files.should_not include(File.expand_path "vimrc")
        end
      end

      context "default does not exist" do
        it "should return the specific file" do
          FileUtils.touch "vimrc.host-work"
          DotFiles.source_files.should include(File.expand_path "vimrc.host-work")
        end
      end
    end

    context "hostname does not match suffix" do
      before :each do
        DotFiles.stub(:hostname).and_return("home")
      end

      context "default exists" do
        it "should return the default file" do
          FileUtils.touch "vimrc"
          FileUtils.touch "vimrc.host-work"
          DotFiles.source_files.should include(File.expand_path "vimrc")
        end
      end

      context "default does not exist" do
        it "should omit the file if no default exists" do
          FileUtils.touch "vimrc.host-work"
          DotFiles.source_files.should_not include(File.expand_path "vimrc.host-work")
        end
      end
    end
  end

  describe "#prepare" do
    it "should return the basename only" do
      DotFiles.prepare("/dotfiles/.vimrc").should == ".vimrc"
    end

    context "leading dot missing" do
      it "should add a leading dot" do
        DotFiles.prepare("vimrc").should == ".vimrc"
      end

      it "should add a leading dot for absolute paths" do
        DotFiles.prepare("/dotfiles/vimrc").should == ".vimrc"
      end
    end

    context "leading dot exists" do
      it "should not add a leading dot" do
        DotFiles.prepare(".vimrc").should == ".vimrc"
      end
    end

    context "host specific" do
      it "should remove host suffixes" do
        DotFiles.stub(:hostname).and_return("work")
        DotFiles.prepare(".vimrc.host-work").should == ".vimrc"
      end
    end
  end

  describe "#hostname" do
    it "should return the hostname" do
      DotFiles.should_receive(:`).and_return("work")
      DotFiles.hostname.should == "work"
    end

    it "should return the hostname without any domain information" do
      DotFiles.should_receive(:`).and_return("work.local")
      DotFiles.hostname.should == "work"
    end
  end
end
