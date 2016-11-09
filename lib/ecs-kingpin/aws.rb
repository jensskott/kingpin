def connectEcs(region)
    begin
        Aws::ECS::Client.new(region: region)
    rescue Aws::ECS::Errors::ServiceError
        Kinglog.log.error "Cant connect to S3"
    end
end

def connectS3(region)
    begin
        Aws::S3::Client.new(region: region)
    rescue Aws::ECS::Errors::ServiceError
        Kinglog.log.error "Cant connect to S3"
    end
end

def awsBucket(region, bucketName)
    s3 = connectS3(region)
    buckets = s3.list_buckets.to_h
    # Extend to hash to do locate
    buckets.extend(Hashie::Extensions::DeepLocate)
    # Locate the correct bucket
    bucket = buckets.deep_locate -> (key, value, _object) { key == :name && value.include?(bucketName) }
    # Do something with value
    if bucket.empty?
        Kinglog.log.info "Creating bucket #{bucketName}!"
        s3.create_bucket(bucket: bucketName)
        Kinglog.log.info 'Enabling bucket versioning!'
        s3.put_bucket_versioning(bucket: bucketName, versioning_configuration: { mfa_delete: 'Disabled', status: 'Enabled' })
    else
        Kinglog.log.info 'Bucket allready exists'
    end
end

# Describe to compare task
def describeTask(taskName, region)
    ecs = connectEcs(region)
    currentTask = ecs.list_task_definition_families({family_prefix: "#{taskName}", status: "ACTIVE", })
    if !currentTask['families'].empty?
        currentTask = ecs.describe_task_definition({ task_definition: "#{taskName}", })
    end
end

# Create task
def createTask(containers, service, region)
    # Create options for task definition
    task = taskOpts(containers,service)
    ecs = connectEcs(region)
    begin
        ecs.register_task_definition(task)
    rescue Aws::ECS::Errors::ServiceError
        Kinglog.log.error "Cant create a task definition"
    end
end

def updateService(containers, service, region)
    task = taskOpts(containers,service)
    ecs = connectEcs(region)
    begin

        Kinglog.log.info "Updating task definition for #{task[:family]}}"
    rescue Aws::ECS::Errors::ServiceError
        Kinglog.log.error "Cant update task defintion"
    end
end
