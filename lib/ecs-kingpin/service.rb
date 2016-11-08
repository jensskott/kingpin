# Create service.tfvars for terraform
def createServiceVars(array, ports)
    product = array[:product]
    service = array[:yaml]['metadata']['name']
    env = array[:env]
    region = array[:region]
    port = ports[0][0]['containerPort']
    containerPort = ports[0][0]['port']
    type = array[:yaml]['type']
    serviceVars = "product: <%= product %>
service: <%= service %>
env: <%= env %>
region: <%= region %>
elb_port: <%= port %>
container_port: <%= containerPort %>
<% if type == \"PublicService\" %>service_type: public<% else %>service_type: private<% end %>"

    # Create a service.tfvars
    renderer = ERB.new(serviceVars)
    File.open('service.tfvars', 'w') do |f|
        f.write renderer.result(binding)
    end
    Kinglog.log.info 'Wrote service.tfvars'
end

# Create service options for aws api
def serviceOpts
end
