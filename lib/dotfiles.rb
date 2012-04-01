module DotFiles
  extend self

  def symlink
    source_files.each do |source|
      target = File.join "~", prepare(source)
      File.symlink source, target unless File.exists? target
    end
  end

  def prepare(file) 
    base = File.basename(file)
    base = base.split(".host-#{hostname}").first
    base = base.prepend(".")
    base.gsub(/\.\./, ".")
  end

  def source_files
    suffix   = "host-#{hostname}"

    defaults = Dir.glob("*") - Dir.glob("*.host-*")
    specific = Dir.glob("*.#{suffix}")
    obsolete = specific.map { |f| f.split(".#{suffix}").first } 

    defaults - obsolete + specific
  end

  def hostname
    `hostname`.strip.split('.').first
  end
end
