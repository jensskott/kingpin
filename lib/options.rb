def fileOpts(file)
  yaml = YAML.load_file("#{file}")
  return yaml
end

def cliOpts()
  opts = Trollop::options do
    version "Kingpin 0.1.0"
    banner <<-EOS
    Manage your ECS resources.

    Usage:
           kinpin [options]
    where [options] are:
    EOS


    opt :region, "Put your aws region here", :type => :string
    opt :env, "Application Environment", :type => :string
    opt :file, "Yaml file to read data from", :type => :string
  end

  # Merge filepath + filename to opts
  opts[:file] = File.expand_path(opts[:file])

  # Check for options needed
  Trollop::die :region, "Define a region" if opts[:region].nil?
  Trollop::die :env, "Define an environment" if opts[:env].nil?
  Trollop::die :file, "You must provide a file" if opts[:file].nil?

  # Check valid extention
  accepted_formats = [".yml", ".yaml"]
  if !accepted_formats.include? File.extname(opts[:file])
    abort "Not a valid file extention"
  end

  # Check valid yaml
  begin
    puts "Validating yaml file : #{opts[:file]}"
    YAML.load_file(opts[:file])
  rescue Exception
    puts "failed to read #{opts[:file]}: #{$!}"
  end

  return opts
end
