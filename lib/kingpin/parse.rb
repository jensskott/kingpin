def parseLabels(array)
  hash = Hash.new
  array.each do |l|
    key = l['name']
    value = l['value']
    hash[key] = value
  end
  return hash
end

def parseContainers(array,labels)
  arr = Array.new
  array.each do |l|
    c = Hash.new
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

def parseService(array)
  arr = Array.new
  array.each do |l|
    unless l['ports'].nil?
      arr << l['ports']
    end
  end
  return arr
end
