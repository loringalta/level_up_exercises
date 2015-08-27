require_relative '../data_statistics'

describe DataStatistics do
  let(:filename) { 'test.json' }
  let(:data_stat) { DataStatistics.new(filename) }

  describe '#convert_data_to_hash' do
    it 'assigns the chi square values to the relevant cohort group' do
      values = {}
      values['A'] = { converted: 5, not_con: 6 }
      values['B'] = { converted: 9, not_con: 6 }
      calc_values = data_stat.convert_data_to_hash
      expect(calc_values['A']).to eq(values['A'])
      expect(calc_values['B']).to eq(values['B'])
    end
  end

  describe '#chi_square' do
    it 'gets the chi_square value for the data_set' do
      expect(data_stat.get_chi_square).to eq(0.4623251)
    end
  end
end
