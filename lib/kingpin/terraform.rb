# Check if terraform is installed on the system
def terrformExecCheck
    `which terraform`
    if $? == false
        Kinglog.log.error 'Terrform executable not found, please install terraform'
        abort
    end
end

# Configure remote s3 bucket for terraform state file
def terrformConfig(array,bucketName)
    product = array[:product]
    service = array[:yaml]['metadata']['name']
    env = array[:env]
    region = array[:region]
    serviceState = "#{service}-#{product}-#{env}.tfstate"
    tfconfig = "terraform remote config -backend=s3 -backend-config=\"bucket=#{bucketName}\" \
    -backend-config=\"key=#{serviceState}\" -backend-config=\"region=#{region}\""
    system tfconfig
    if $? != 0
        Kinglog.log.error "Could not apply terraform config. Errorcode #{$?}"
        abort
    end
end

# Run terraform to apply config
def terraformRun
    tf = "terraform apply"
    tfget = "terraform get"
    system tfget
    system tf
    if $? != 0
        Kinglog.log.error "Can't run terraform config. Error: #{$?}"
        abort
    end
end

# Clean up all temporary files from terraform
def terraformCleanup
    FileUtils.rm_rf('terraform.tfstate')
    FileUtils.rm_rf('terraform.tfstate.backup')
    FileUtils.rm_rf('mkmf.log')
    FileUtils.rm_rf('.terraform')
    FileUtils.rm_rf('task-definition.json')
    FileUtils.rm_rf('service.tfvars')
    Kinglog.log.info 'Removed all temporary files'
end
