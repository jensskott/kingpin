require 'aws-sdk'
#require_relative 'parse'
require 'yaml'

opts = YAML.load_file(ARGV.shift)
service = ARGV.shift
env = ARGV.shift
region = ARGV.shift
ecs = Aws::ECS::Client.new(region: region)

=begin
ecs.register_task_definition({
  container_definitions: [
    {
      name: opts['task'][env]['name'],
      essential: true,
      image: opts['task'][env]['image'],
      memory: opts['task'][env]['mem'],
      docker_labels: opts['task'][env]['lables'],
      links: ["#{link}:#{link}"],
      #environment: [opts['task'][env]['environment']],
    },
    {
      name: opts['task'][env]['childs'][opts['task'][env]['require']]['name'],
      essential: opts['task'][env]['childs'][opts['task'][env]['require']]['essential'],
      image: opts['task'][env]['childs'][opts['task'][env]['require']]['image'],
      memory: opts['task'][env]['childs'][opts['task'][env]['require']]['mem'],
    },
  ],
  family: serviceName,
})
=end



service = ecs.describe_services({
  services: [
    serviceName,
  ],
})

if service.data.services.empty?
  ecs.create_service({
    desired_count: opts['spec']['scaling']['desired'],
    service_name: serviceName,
    task_definition: serviceName,
  })
else
  ecs.update_service({
    service: serviceName,
    task_definition: serviceName,
  })
end


# TODO Create or update LB and link it to service!
