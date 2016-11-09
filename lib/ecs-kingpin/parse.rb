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
        c['essential'] = l['essential'] # required
        c['image'] = l['image'] # required
        c['environment'] = l['env'] unless l['env'].nil?
        c['memory'] = l['resources']['memory'] # required
        c['cpu'] = l['resources']['cpu'] unless l['resources']['cpu'].nil?
        c['docker_labels'] = labels unless labels.empty?
        c['links'] = l['links'] unless l['links'].nil?
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
