require "thor"
require "erb"
require "fileutils"

class Configure < Thor
 
  # ...
  def self.exit_on_failure?
    true
  end 
  
  class << self
    def options(options={})
      
      options.each do |option_name, option_settings|
        option option_name, option_settings  
      end
  
    end
  end
  
  module ERBRenderer
    
    def render_from(template_path)
      ERB.new(File.read(template_path), 0, '<>').result binding
    end
    
  end  
  
  class YARNTimeLineServerConfiguration
    include ERBRenderer
    attr_accessor :hostname
    
  end
  

  desc "timelineserver", "Configure the YARN Time Line Server"
  option :hostname, :required => true
  def timelineserver
    
    configuration = YARNTimeLineServerConfiguration.new
    configuration.hostname = options[:hostname]
      
    File.write '/etc/hadoop/yarn-site.xml',
      configuration.render_from('/etc/hadoop/yarn-site.xml.erb')   
    
  end
  
end

Configure.start(ARGV)