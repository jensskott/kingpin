# Require Gems
require 'aws-sdk'
require 'yaml'
require 'trollop'

# Require local libs
require_relative 'aws'
require_relative 'parse'
require_relative 'options'
require_relative 'log'

# Get options from CLI and file
opts = cliOpts

# Parse data from cli and file
labels = parseLabels(opts[:yaml]['metadata']['labels'])
servicePort = parseService(opts[:yaml]['spec']['containers'])
containers = parseContainers(opts[:yaml]['spec']['containers'],labels)

puts labels
puts servicePort
puts containers

case opts[:command]
when "aws"
  puts "use aws cli"
when "terraform"
  puts "use terraform"
end
