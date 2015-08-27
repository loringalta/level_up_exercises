require 'abanalyzer'
require_relative 'analyzer'
require_relative 'cohort_statistics'
require 'pp'

class DataStatistics
  attr_accessor :cohort_data
  def initialize(filename)
    @cohort_data = Analyzer.new(filename).parse_data
  end

  def convert_data_to_hash(values = {})
    @cohort_data.each do |cohort, _|
      values[cohort] =  CohortStatistics.new(cohort, @cohort_data).values
    end
    values
  end

  def chi_square
    tester = ABAnalyzer::ABTest.new convert_data_to_hash
    pp tester.chisquare_p.round(7)
  end
end
# filename = 'test.json'
# DataStatistics.new(filename).chi_square
