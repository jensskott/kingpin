# Require Gems
require 'aws-sdk'
require 'yaml'
require 'trollop'
require 'logger'
require 'json'
require 'erb'

# Require local libs
require_relative 'kingpin/aws'
require_relative 'kingpin/parse'
require_relative 'kingpin/options'
require_relative 'kingpin/log'
require_relative 'kingpin/terraform'

# Get options from CLI and file
class Kingpin
  # Get options from cli
  opts = cliOpts

  # Define varaibles for service and tasks
  labels = parseLabels(opts[:yaml]['metadata']['labels'])
  servicePort = parseService(opts[:yaml]['spec']['containers'])
  containers = parseContainers(opts[:yaml]['spec']['containers'],labels)

  case opts[:command]
  when "aws"
    puts "use aws cli"
  when "terraform"
    puts "use terraform"
    createTaskDefinition(containers,opts[:yaml]['metadata']['name'])
  end


end
