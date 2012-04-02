class DotFiles
  attr_reader :defaults, :host_specific, :merged

  HOST_SUFFIX = "host-"
  BLACKLIST   = %w{Rakefile README.md}

  def self.symlink
    puts "Calculating symlinks..."
    DotFiles.new.symlink
    puts "Done. <3:-)"
  end

  def symlink
    skip_all      = false
    overwrite_all = false
    backup_all    = false
    mapping       = { File.expand_path(".") => File.expand_path("~/.dotfiles") }

    merged.each_with_object(mapping) do |source, m|
      mapping[File.expand_path(source)] = File.expand_path(targetify(source))
    end

    mapping.each do |source, target|
      overwrite = false
      backup    = false
      skip      = false
      
      if File.exists?(target) || File.symlink?(target)
        unless skip_all || overwrite_all || backup_all
          puts "File already exists: #{target}, what do you want to do? [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all"
          case STDIN.gets.chomp
          when 'o' then overwrite = true
          when 'b' then backup = true
          when 'O' then overwrite_all = true
          when 'B' then backup_all = true
          when 'S' then skip_all = true
          when 's' then next
          end
        end

        FileUtils.rm_rf(target) if overwrite || overwrite_all
        FileUtils.copy(target, "#{target}.backup") if backup || backup_all
      end

      unless skip || skip_all 
        puts "Linking #{source} to #{target}"
        File.symlink source, target 
      end
    end
  end

  def targetify(file) 
    base = File.basename(file)
    base = base.split(".#{host_suffix}").first
    base = base.prepend(".")
    base = base.gsub(/\.\./, ".")
    File.join "~", base
  end

  def mapping
    mapping = merged.each_with_object({}) do |source, hash|
      hash[File.expand_path source] = targetify(source)
    end
    mapping[File.expand_path "."] = File.expand_path "~/.dotfiles"
    mapping
  end

  def defaults
    Dir.glob("*") - Dir.glob("*.#{HOST_SUFFIX}*") - blacklist
  end

  def host_specific
    Dir.glob("*.#{host_suffix}") - blacklist
  end

  def merged
    (defaults + host_specific) - host_specific.map { |f| f.split(".#{host_suffix}").first }
  end

  def blacklist
    BLACKLIST
  end

  def host_suffix
    "#{HOST_SUFFIX}#{hostname}"
  end

  def hostname
    @hostname ||= `hostname`.strip.split('.').first
  end
end

