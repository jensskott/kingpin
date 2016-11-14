def fileOpts(file,profile)
    yaml = YAML.load_file(file)
    yaml

    #yaml = Psych.load_stream(open(file))
    #yaml.each do |l|
#        if l.keys ==
#    end
end

def cliOpts
    opts = Trollop.options do
        version 'ecs-kingpin 0.1.0'
        banner <<-EOS
    Manage your ECS resources.

    Usage:
           ecs-kinpin [options]
    where [options] are:
    EOS
        # Get all options we need
        opt :region, 'Put your aws region here', type: :string
        opt :env, 'Application Environment', type: :string
        opt :product, 'The product where your services are related', type: :string
        opt :profile, 'Profile to use with deployment', type: :string, default: 'default'
        opt :command, 'aws, terraform or debug', type: :string, default: 'aws'
        opt :file, 'Yaml file to read data from', type: :string
        opt :local, 'Use local config files', type: :bool, default: false
    end

    # Check for options needed
    Trollop.die :region, 'Define a region' if opts[:region].nil?
    Trollop.die :env, 'Define an environment' if opts[:env].nil?
    Trollop.die :product, 'Define a product' if opts[:product].nil?
    Trollop.die :file, 'Define a file' if opts[:file].nil?

    # Merge filepath + filename to opts
    opts[:file] = File.expand_path(opts[:file])

    # Check if file exists
    unless File.exist? (opts[:file])
        Kinglog.log.error 'File does not exist'
        abort
    end

    # Check valid extention
    accepted_formats = ['.yml', '.yaml']
    unless accepted_formats.include? File.extname(opts[:file])
        Kinglog.log.error 'Not a valid yaml extention'
        abort
    end

    # Check valid yaml
    Kinglog.log.info "Validating yaml file : #{opts[:file]}"
    if YAML.load_file(opts[:file]) == false
        Kinglog.log.error "failed to read #{opts[:file]}: #{$ERROR_INFO}"
        abort
    end

    # Puts all file options into opts[:yaml]
    # Accessable trough opts[:yaml]['metadata'] ....
    opts[:yaml] = fileOpts(opts[:file],opts[:profile])
    opts
end
