module DotFiles
  extend self

  def symlink
    mapping.each do |source, target|
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
    obsolete = specific.map  { |f| f.split(".#{suffix}").first } 
    ignored  = blacklist.map { |f| File.expand_path f}

    (defaults + specific) - obsolete - ignored 
  end

  def mapping
    source_files.each_with_object({}) do |source, hash|
      hash[source] = File.join "~", prepare(source)
    end
  end

  def hostname
    `hostname`.strip.split('.').first
  end

  def blacklist
    @blacklist ||= %w{Rakefile README.md}
  end
end
