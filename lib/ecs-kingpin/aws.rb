def connectEcs(region)
    Aws::ECS::Client.new(region: region)
end

def connectS3(region)
    Aws::S3::Client.new(region: region)
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
        Kinglog.log.info "Enabling bucket versioning!"
        s3.put_bucket_versioning(bucket: bucketName, versioning_configuration: { mfa_delete: 'Disabled', status: 'Enabled' })
    else
        Kinglog.log.info "Bucket allready exists"
    end
end
