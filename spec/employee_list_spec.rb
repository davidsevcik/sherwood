require_relative '../lib/employee_list'

describe EmployeeList do
  subject { EmployeeList.from_csv File.join(File.dirname(__FILE__), 'test.csv') }

  describe '#structure_by' do
    context 'manager' do
      it 'returns structured list' do
        list = subject.structure_by(:manager)
        expect(list[4].employee.name).to eq('Will Scarlett')
        expect(list[4].level).to eq(2)
        expect(list.last.employee.name).to eq('Tom Jones')
        expect(list.last.level).to be_nil
      end
    end

    context 'foo' do
      it 'raises error' do
        expect { subject.structure_by(:foo) }.to raise_error(ArgumentError)
      end
    end
  end


  describe '#group_by' do
    context 'department' do
      it 'returns structured list' do
        grouped = subject.group_by(:department)
        expect(grouped['Villainy and Acquisitions']).to have(2).items
        expect(grouped['Villainy and Acquisitions'][1].name).to eq('The Sherrif')
      end
    end

    context 'salary' do
      it 'returns structured list' do
        grouped = subject.group_by(:salary)
        expect(grouped['130']).to have(2).items
        expect(grouped['130'][0].name).to eq('Guy Gisbourne')
      end
    end

    context 'foo' do
      it 'raises error' do
        expect { subject.group_by(:foo) }.to raise_error(ArgumentError)
      end
    end
  end
end
