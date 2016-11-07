require 'yaml'
require 'erb'
require 'json'

opts = YAML.load_file(ARGV.shift)

# Map yaml objects to variables

def parseLabels(array, arrayName)
  instance_variable_set("@#{arrayName}", Hash.new)
  array.each do |l|
    key = l['name']
    value = l['value']
    instance_variable_get("@#{arrayName}")[key] = value
  end
end

def parseContainers(array, arrayName)
  instance_variable_set("@#{arrayName}", Array.new)
  array.each do |l|
    c = Hash.new
    c['name'] = l['name']
    c['essential'] = l['essential']
    c['image'] = l['image']
    c['environment'] = l['env']
    c['memory'] = l['resources']['memory']
    c['cpu'] = l['resources']['cpu']
    #c['mountPoints'] = l['vlumes']
    c['docker_labels'] = @docker_labels
    c['links'] = l['links']

    instance_variable_get("@#{arrayName}") << c
  end
end

#type = opts['type']
serviceName = opts['metadata']['name']
parseLabels(opts['metadata']['labels'], 'docker_labels') # second value is the varaible
parseContainers(opts['spec']['containers'], 'containers')

last = @containers.last

task_definition = "{\"container_definitions\": [
    <% @containers.each do |array| %>
      <%= array.to_json %><% unless last['name'] == array[\"name\"] %>,<% end %>
    <% end %>
  ],
  \"family\": \"<%= serviceName %>\"
}
"

service = "servicename = \"<%= serviceName %>\"
"

renderer = ERB.new(task_definition)
File.open('task-definition.json', 'w') do |f|
  f.write renderer.result(binding)
end

renderer = ERB.new(service)
File.open('service.tfvars', 'w') do |f|
  f.write renderer.result(binding)
end
