# Create task-definition for terraform
def createTaskDefinition(array, service)
    json_opts = array.to_json
    parsed = JSON.parse(json_opts)
    last = parsed.last

    task_definition = "{\"container_definitions\": [
      <% parsed.each do |array| %><%= array.to_json %><% unless last[\"name\"] == array[\"name\"] %>,<% end %><% end %>
      ],
      \"family\": \"<%= service %>\"
    }"

    # Create a task-definition.json
    renderer = ERB.new(task_definition)
    File.open('task-definition.json', 'w') do |f|
        f.write renderer.result(binding)
    end
    Kinglog.log.info 'Wrote task-defintion.json'
end

# Create task options for aws api
def taskOpts(array,service)
    #json_opts = array.to_json
    #parsed = JSON.parse(json_opts)
    task_definition = "{family: #{service}, container_definitions:#{array}}"
    puts task_definition.to_h
    return task_definition
end
