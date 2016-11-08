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
require_relative 'ecs-kingpin/aws'
require_relative 'ecs-kingpin/parse'
require_relative 'ecs-kingpin/options'
require_relative 'ecs-kingpin/log'
require_relative 'ecs-kingpin/terraform'
require_relative 'ecs-kingpin/service'
require_relative 'ecs-kingpin/task'

# Get options from CLI and file
class Kingpin
    # Get options from cli
    opts = cliOpts

    # Define varaibles for service and tasks
    labels = parseLabels(opts[:yaml]['metadata']['labels'])
    servicePort = parseService(opts[:yaml]['spec']['containers'])
    containers = parseContainers(opts[:yaml]['spec']['containers'], labels)

    case opts[:command]
    when 'debug'
        puts 'Output everything in standard out'
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
