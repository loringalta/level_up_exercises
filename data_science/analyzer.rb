require 'json'
require 'pp'

class Analyzer

  def initialize(filename)
    @filename = filename
  end

  def parse_data
    data = JSON.parse(File.read(@filename))
    group_data = Hash.new { [] }
    data.each_with_object({}) do |data_line, _|
      group_data[data_line['cohort']] <<= data_line['result']
    end
    group_data
  end
end
