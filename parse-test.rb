require 'yaml'
require 'erb'

opts = YAML.load_file(ARGV.shift)
env = ARGV.shift
serviceName = opts['service']['name'] + "-#{env}"

task_definition = "{container_definitions: [
    {
      <% opts['task'][env].each do |k,v| %>
      <%= k %>: <%= v %>,
      <% end %>
      privileged: false
    },
  ],
  family: \"<%= serviceName %>\",
}
"

renderer = ERB.new(task_definition)
puts renderer.result()
