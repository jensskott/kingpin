require 'yaml'
require 'erb'
require 'json'

opts = YAML.load_file(ARGV.shift)
env = ARGV.shift
serviceName = opts['service']['name'] + "-#{env}"

task_definition = "{\"container_definitions\": [
    <% opts['task'][env].each do |k,v| %>
    {
      <% v.each do |k,v| %>
      \"<%= k %>\": \"<%= v %>\",
      <% end %>
      \"privileged\": false
    },
    <% end %>
  ],
  \"family\": \"<%= serviceName %>\",
}
"

renderer = ERB.new(task_definition)
File.open('task-definition.json', 'w') do |f|
  f.write renderer.result(binding)
end
