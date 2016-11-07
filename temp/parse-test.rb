require 'yaml'
require 'erb'
require 'json'

opts = YAML.load_file(ARGV.shift)
env = ARGV.shift
serviceName = opts['service']['name'] + "-#{env}"

json_opts = opts['task'][env].to_json
parsed = JSON.parse(json_opts)
last = parsed.keys.to_a.last



task_definition = "{\"container_definitions\": [
    <% parsed.each do |name,data| %>
      <%= data.to_json %><% unless last == data[\"name\"] %>,<% end %>
    <% end %>
  ],
  \"family\": \"<%= serviceName %>\"
}
"

renderer = ERB.new(task_definition)
File.open('task-definition.json', 'w') do |f|
  f.write renderer.result(binding)
end
