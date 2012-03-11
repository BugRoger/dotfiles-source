module DotFiles
  extend self

  def symlink
    source_files.each do |file|
      begin
        File.symlink file, File.join("~", File.basename(DotFiles.dotify(file)))
      rescue Errno::EEXIST
      end
    end
  end

  def dotify(file) 
    File.basename(file).prepend(".").gsub(/\.\./, ".")
  end

  def source_files
    return Dir.glob("*")
  end
end
