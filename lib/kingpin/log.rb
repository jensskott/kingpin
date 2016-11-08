class Kinglog
    def self.log
        # Create logdir
        logdir = Dir.pwd + '/log'
        Dir.mkdir logdir unless Dir.exist?(logdir)
        # Create log
        if @logger.nil?
            @logger = Logger.new STDOUT
            # @logger = Logger.new "#{logdir}/kingpin.log"
            @logger.level = Logger::DEBUG
            @logger.datetime_format = '%Y-%m-%d %H:%M:%S '
        end
        @logger
    end
end
