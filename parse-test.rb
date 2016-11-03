require 'yaml'
require 'erb'

opts = YAML.load_file(ARGV.shift)
env = ARGV.shift
serviceName = opts['service']['name'] + "-#{env}"
if !opts['task'][env]['require'].nil?
  link = opts['task'][env]['childs'][opts['task'][env]['require']]['name']
  puts link
end

puts env
puts serviceName

puts "\nNow comes all the values\n"
puts opts.inspect

task_definition = "container_definitions: [
    {
      <% opts['task'][env].each do |k,v| %>
      <%= k %>: <%= v %>,
      <% end %>
      privileged: false
    },
  ],
"

renderer = ERB.new(task_definition)
puts renderer.result()
