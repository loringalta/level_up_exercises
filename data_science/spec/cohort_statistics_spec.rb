require_relative '../cohort_statistics.rb'
require_relative '../data_statistics.rb'
require 'abanalyzer'

describe CohortStatistics do
  let(:filename) { 'test.json' }
  let(:cohort_data) { DataStatistics.new(filename).cohort_data }
  let(:cohort_stat_A) { CohortStatistics.new('A', cohort_data) }

  describe '#cohort_conversion_freq' do
    context 'calculates the number of people converted' do
      it 'counts the number of ones' do
        expect(cohort_stat_A.converted).to eq(5)
      end
    end
  end

  describe '#cohort_confidence_interval' do
    it 'calculates the confidence interval at 95%' do
      ab_confidence = ABAnalyzer.confidence_interval(5, 11, 0.95)
      bottom = cohort_stat_A.cohort_confidence_interval[0]
      top = cohort_stat_A.cohort_confidence_interval[1]
      expect(ab_confidence[0]).to be_within(0.01).of(bottom)
      expect(ab_confidence[1]).to be_within(0.01).of(top)
    end
  end

  describe '#values' do
    it 'creates a hash of non-converted and converted people' do
      values = {}
      values['A'] = { converted: 5, not_con: 6 }
      calc_values = cohort_stat_A.values
      expect(calc_values).to eq(values['A'])
    end
  end

  describe '#cohort_size' do
    it 'calculates the size of the inputted cohort' do
      expect(cohort_stat_A.send(:cohort_size)).to eq(11)
    end
  end

  describe '#standard_error' do
    it 'calculates standard error' do
      conv_frq = cohort_stat_A.cohort_conversion_freq
      cohort_size = cohort_stat_A.send(:cohort_size)
      calc_std_err = cohort_stat_A.send(:standard_error, conv_frq, cohort_size)
      expect(calc_std_err).to be_within(0.001).of(0.1501)
    end
  end

  context 'calculates the number of people not converted' do
    let(:not_converted) { cohort_stat_A.not_con }
    it 'counts the number of 0' do
      expect(cohort_stat_A.not_con).to eq(not_converted)
    end
  end
end
