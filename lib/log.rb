require 'logger'

class KingLog
  def self.log

    # Create logdir
    logdir = Dir.pwd + "/log"
    if !Dir.exists?(logdir)
      Dir.mkdir logdir
    end

    # Create log
    if @logger.nil?
      @logger = Logger.new STDOUT
      #@logger = Logger.new "#{logdir}/kingpin.log"
      @logger.level = Logger::DEBUG
      @logger.datetime_format = '%Y-%m-%d %H:%M:%S '
    end
    @logger
  end
end
