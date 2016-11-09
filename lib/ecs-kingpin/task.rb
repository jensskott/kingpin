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
def taskOpts(array, service)
    taskDefinition = { family: service, container_definitions: array }
    taskDefinition
end

def diffTaskDefinition(containers, service, currentTask)
    task = taskOpts(containers, service)
    currentTask = currentTask.to_h
    h1 = task[:container_definitions][0].to_h
    h2 = currentTask[:task_definition][:container_definitions][0].to_h
    # Compare tasks and yaml to see if update is needed
    json1 = h1.to_json
    json2 = h2.to_json
    first, second = Yajl::Parser.parse(json1), Yajl::Parser.parse(json2)
    return JsonCompare.get_diff(first, second)
end
