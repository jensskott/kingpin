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
    opt :command, "Use aws cli or terraform to create service", :type => :string, :default => "aws"
    opt :file, "Yaml file to read data from", :type => :string
  end

  # Check for options needed
  Trollop::die :region, "Define a region" if opts[:region].nil?
  Trollop::die :env, "Define an environment" if opts[:env].nil?
  Trollop::die :file, "Define a file" if opts[:file].nil?

  # Merge filepath + filename to opts
  opts[:file] = File.expand_path(opts[:file])

  # Check if file exists
  if !File.exists? (opts[:file])
    Kinglog.log.error "File does not exist"
    abort
  end

  # Check valid extention
  accepted_formats = [".yml", ".yaml"]
  if !accepted_formats.include? File.extname(opts[:file])
    Kinglog.log.error "Not a valid yaml extention"
    abort
  end

  # Check valid yaml
  Kinglog.log.info "Validating yaml file : #{opts[:file]}"
  if YAML.load_file(opts[:file]) == false
    Kinglog.log.error "failed to read #{opts[:file]}: #{$!}"
    abort
  end

  # Puts all file options into opts[:yaml]
  # Accessable trough opts[:yaml]['metadata'] ....
  opts[:yaml] = fileOpts(opts[:file])
  return opts
end
