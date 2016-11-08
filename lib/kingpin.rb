# Require Gems
require 'aws-sdk'
require 'yaml'
require 'trollop'

# Require local libs
require_relative 'aws'
require_relative 'parse'
require_relative 'options'

# Get options from CLI and file
opts = cliOpts
yaml = fileOpts(opts[:file])

# Parse data from cli and file
servicePort = parseService(yaml['spec']['containers'])
puts servicePort
containers = parseContainers(yaml['spec']['containers'])
puts containers
