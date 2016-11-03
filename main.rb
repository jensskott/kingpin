require 'yaml'
require 'aws-sdk'

opts = YAML.load_file(ARGV.shift)
env = ARGV.shift
serviceName = opts['service']['name'] + "-#{env}"

ecs = Aws::ECS::Client.new(region: opts['aws']['region'])

ecs.register_task_definition({
  container_definitions: [
    {
      name: opts['task'][env]['name'],
      essential: true,
      image: opts['task'][env]['image'],
      memory: opts['task'][env]['mem'],
      docker_labels: opts['task'][env]['lables'],
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

service = ecs.describe_services({
  services: [
    serviceName,
  ],
})

if service.data.services.empty?
  ecs.create_service({
    desired_count: opts['service'][env]['desired_count'],
    service_name: serviceName,
    task_definition: serviceName,
  })
else
  ecs.update_service({
    service: serviceName,
    task_definition: serviceName,
  })
end
