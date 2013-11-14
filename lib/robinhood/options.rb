module Robinhood
  # Module used to extract the arguments passed to the robinhood executable
  #
  module Options
    class << self
      # Public: Extract arguments and fill a hash with the different values retrieved
      #
      # args - String that contains the ARGV value passed to the robinhood executable
      #        an example will be: 'start ROBINHOOD_FILE_PATH=robinhood_file.rb PIDS_DIR=tmp/pids'
      #
      # Retursn a hash with the arguments retrieved
      def parse(args)
        options = {}

        args.each do |arg|
          case arg
            when 'start'
              options[:start] = true
            when 'stop'
              options[:stop] = true
            when /LOGFILE/
              options[:log_dir] = arg.split('=')[1]
            when /PIDS_DIR/
              options[:pids_dir] = arg.split('=')[1]
            when /ROBINHOOD_FILE_PATH/
              options[:robinhood_file_path] = arg.split('=')[1]
            else
              p "option #{arg} is not allowed"
          end
        end

        options
      end
    end
  end
end