module DotFiles
  extend self

  def symlink
    source_files.each do |source|
      target = File.join "~", dotify(source)
      File.symlink source, target unless File.exists? target
    end
  end

  def dotify(file) 
    File.basename(file).prepend(".").gsub(/\.\./, ".")
  end

  def source_files
    return Dir.glob("*")
  end
end
