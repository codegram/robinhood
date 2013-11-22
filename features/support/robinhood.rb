require 'fileutils'

module Spinach::Robinhood
  def write_robinhood(content)
    FileUtils.mkdir_p('tmp')
    File.open('tmp/Robinhood', 'w') do
      content
    end
  end
end
