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
  @servicePort = Array.new
  array.each do |l|
    c = Hash.new
    c['name'] = l['name']
    c['essential'] = l['essential']
    c['image'] = l['image']
    c['environment'] = l['env']
    c['memory'] = l['resources']['memory']
    c['cpu'] = l['resources']['cpu']
    c['mountPoints'] = l['volumes']
    c['docker_labels'] = @docker_labels
    c['links'] = l['links']
    unless l['ports'].nil?
      @servicePort << l['ports']
    end
    instance_variable_get("@#{arrayName}") << c
  end
end

#type = opts['type']
serviceName = opts['metadata']['name']
parseLabels(opts['metadata']['labels'], 'docker_labels') # second value is the varaible
parseContainers(opts['spec']['containers'], 'containers')
volumes = opts['spec']['volumes']
@servicePort.each do |k,v|
  @containerPort = k['containerPort']
  @elb_port = k['port']
  @protocol = k['protocol']
end
serviceType = opts['type']

last = @containers.last

task_definition = "{\"container_definitions\": [
    <% @containers.each do |array| %>
      <%= array.to_json %><% unless last['name'] == array[\"name\"] %>,<% end %>
    <% end %>
  ],
  \"family\": \"<%= serviceName %>\",
  \"volumes\": [<% volumes.each do |k| %>
    <%= k.to_json %>
  <% end %>]
  }
"

service = "product: <%= serviceName %>
service: <%= ARGV.shift %>
env: <%= ARGV.shift %>
region: <%= ARGV.shift %>
elb_port: <%= @containerPort %>
container_port: <%= @elb_port %>
<% if serviceType == \"PublicService\" %>
service_type: public
<% else %>
service_type: private
<% end %>
"

renderer = ERB.new(task_definition)
File.open('task-definition.json', 'w') do |f|
  f.write renderer.result(binding)
end

renderer = ERB.new(service)
File.open('service.tfvars', 'w') do |f|
  f.write renderer.result(binding)
end
