require 'optparse'

module Robinhood
  module Options
    class << self
      def parse(args)
        options = {}

        args.each do |arg|
          case arg
            when 'start'
              options[:start] = true
            when 'stop'
              options[:stop] = true
            when /LOGFILE/
              options[:logfile] = arg.split('=')[1]
            when /PIDS_DIR/
              options[:pids_dir] = arg.split('=')[1]
            else
              p "option #{arg} is not allowed"
          end
        end

        options
      end
    end
  end
end