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
require 'hashdiff'

# Require local libs
require_relative 'ecs-kingpin/aws' # All aws related calls
require_relative 'ecs-kingpin/parse' # Parse all data from files and input
require_relative 'ecs-kingpin/options' # All options that will be needed for the app
require_relative 'ecs-kingpin/log' # Just loggin
require_relative 'ecs-kingpin/terraform' # Terraform related calls
require_relative 'ecs-kingpin/service' # Handle service options and parsing
require_relative 'ecs-kingpin/task' # Handle task options and parsing

# Get options from CLI and file
class Kingpin
    # Get options from cli
    opts = cliOpts

    # Define varaibles for service and tasks
    labels = parseLabels(opts[:yaml]['metadata']['labels'])
    servicePort = parseService(opts[:yaml]['spec']['containers'])
    containers = parseContainers(opts[:yaml]['spec']['containers'], labels)
    service = opts[:yaml]['metadata']['name']
    region = opts[:region]

    case opts[:command]
    when 'debug'
        puts 'Output everything in standard out'
    when 'aws'
        Kinglog.log.info 'Running AWS api to configure ECS tasks and services'
        currentTask = describeTask(service,region)
        if currentTask.nil?
            createTask(containers, service, region)
        else
            Kinglog.log.info 'Task allready exsists, checking if update is needed'
            if diffTaskDefinition(containers, service, currentTask) == true
                Kinglog.log.info 'No update needed'
            else
                #updateTask()
                puts "updates goes here"
            end

        end
    when 'terraform'
        Kinglog.log.info 'Running terraform to configure ECS tasks and services'
        terrformExecCheck
        createTaskDefinition(containers, service)
        createServiceVars(opts, servicePort)
        if opts[:local] == false
            bucketName = "terraformstate-ecs-#{opts[:product]}-#{opts[:env]}-#{region}"
            awsBucket(region, bucketName)
            terrformConfig(opts, bucketName)
        end
        terraformRun
        terraformCleanup if opts[:local] == false
    end
end
