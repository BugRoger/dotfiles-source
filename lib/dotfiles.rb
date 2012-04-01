module DotFiles
  extend self

  def symlink
    puts "Mapping: #{mapping.inspect}"
    mapping.each do |source, target|
      unless File.exists?(target)
        puts "Linking #{source} to #{target}"
        File.symlink source, target 
      end
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

    (defaults + specific) - obsolete - blacklist 
  end

  def mapping
    mapping = source_files.each_with_object({}) do |source, hash|
      target = File.expand_path(File.join "~", prepare(source)) 
      hash[File.expand_path source] = target
    end
    mapping[File.expand_path "."] = File.expand_path "~/.dotfiles"
    mapping
  end

  def hostname
    `hostname`.strip.split('.').first
  end

  def blacklist
    @blacklist ||= %w{Rakefile README.md}
  end
end
