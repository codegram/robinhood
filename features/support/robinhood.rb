require 'fileutils'

module Spinach::Robinhood
  def write_robinhood(content)
    FileUtils.mkdir_p('tmp')
    File.open('tmp/Robinhood', 'w') do |f|
      f.write(content)
    end
  end
end
