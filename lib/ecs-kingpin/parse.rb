# Parse all the lables from the yaml file
def parseLabels(array)
    hash = {}
    array.each do |l|
        key = l['name']
        value = l['value']
        hash[key] = value
    end
    hash
end

# Parse containerdata from the yaml file
def parseContainers(array, labels)
    arr = []
    array.each do |l|
        log = []
        c = {}
        c['name'] = l['name'] # required
        c['image'] = l['image'] # required
        if l['resources']['cpu'].nil?
            c['cpu'] = 0
        else
            c['cpu'] = l['resources']['cpu']
        end
        c['memory'] = l['resources']['memory'] # required
        c['links'] = l['links'] unless l['links'].nil?
        c['port_mappings'] = []
        c['essential'] = l['essential'] # required
        if l['env'].nil?
            c['environment'] = []
        else
            c['environment'] = l['env']
        end
        c['mount_points'] = []
        c['volumes_from'] = []
        c['docker_labels'] = labels
        arr << c
    end
    arr
end

# Parse service variables and return them
def parseService(array)
    arr = []
    array.each do |l|
        arr << l['ports'] unless l['ports'].nil?
    end
    arr
end
