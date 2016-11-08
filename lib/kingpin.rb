# Require Gems
require 'aws-sdk'
require 'yaml'
require 'trollop'
require 'logger'

# Require local libs
require_relative 'kingpin/aws'
require_relative 'kingpin/parse'
require_relative 'kingpin/options'
require_relative 'kingpin/log'

# Get options from CLI and file
class Kingpin
    opts = cliOpts

    ## Variables
    # Parse data from cli and file
    labels = parseLabels(opts[:yaml]['metadata']['labels'])
    servicePort = parseService(opts[:yaml]['spec']['containers'])
    containers = parseContainers(opts[:yaml]['spec']['containers'],labels)

    # Other variables

    # Choose tool to create service
    case opts[:command]
    when "aws"
      puts "use aws cli"
    when "terraform"
      puts "use terraform"
    end
end
