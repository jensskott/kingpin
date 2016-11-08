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
        c = {}
        c['name'] = l['name']
        c['essential'] = l['essential']
        c['image'] = l['image']
        c['environment'] = l['env']
        c['memory'] = l['resources']['memory']
        c['cpu'] = l['resources']['cpu']
        c['mountPoints'] = l['volumes']
        c['docker_labels'] = labels
        c['links'] = l['links']
        c['logConfiguration'] = l['logs']
        arr << c
    end
    return arr
end

# Parse service variables and return them
def parseService(array)
    arr = []
    array.each do |l|
        arr << l['ports'] unless l['ports'].nil?
    end
    return arr
end
