# Require Gems
require 'aws-sdk'
require 'yaml'
require 'trollop'
require 'logger'
require 'json'
require 'erb'
require 'fileutils'
require 'mkmf'
require 'hashie'

# Require local libs
require_relative 'kingpin/aws'
require_relative 'kingpin/parse'
require_relative 'kingpin/options'
require_relative 'kingpin/log'
require_relative 'kingpin/terraform'
require_relative 'kingpin/service'
require_relative 'kingpin/task'

# Get options from CLI and file
class Kingpin
    # Get options from cli
    opts = cliOpts

    # Define varaibles for service and tasks
    labels = parseLabels(opts[:yaml]['metadata']['labels'])
    servicePort = parseService(opts[:yaml]['spec']['containers'])
    containers = parseContainers(opts[:yaml]['spec']['containers'], labels)

    case opts[:command]
    when 'aws'
        puts 'use aws cli'
    when 'terraform'
        Kinglog.log.info 'Running terraform to configure ECS environment'
        terrformExecCheck
        createTaskDefinition(containers, opts[:yaml]['metadata']['name'])
        createServiceVars(opts, servicePort)
        if opts[:local] == false
            bucketName = "terraformstate-ecs-#{opts[:product]}-#{opts[:env]}-#{opts[:region]}"
            awsBucket(opts[:region], bucketName)
            terrformConfig(opts,bucketName)
        end
        terraformRun
        terraformCleanup if opts[:local] == false
    end
end
