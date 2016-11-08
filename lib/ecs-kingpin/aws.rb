def connectEcs(region)
    Aws::ECS::Client.new(region: region)
end

def awsBucket(region, bucketName)
    # connect to s3
    s3 = Aws::S3::Client.new(
        region: region
    )
    buckets = s3.list_buckets.to_h
    buckets.extend(Hashie::Extensions::DeepLocate)
    bucket = buckets.deep_locate -> (key, value, _object) { key == :name && value.include?(bucketName) }
    if bucket.empty?
        Kinglog.log.info "Creating bucket #{bucketName}!"
        s3.create_bucket(bucket: bucketName)
        Kinglog.log.info "Enabling bucket versioning!"
        s3.put_bucket_versioning(bucket: bucketName, versioning_configuration: { mfa_delete: 'Disabled', status: 'Enabled' })
    else
        Kinglog.log.info "Bucket allready exists"
    end
end
