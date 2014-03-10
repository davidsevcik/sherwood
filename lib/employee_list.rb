require 'CSV'
require_relative 'employee'


EmployeeWithLevel = Struct.new(:employee, :level)


class EmployeeList

  def initialize records
    unless records.is_a?(Array) and (records.empty? || records[0].is_a?(Employee))
      raise ArgumentError.new("You have to pass array of Employee instances")
    end
    @records = records
  end


  def self.from_csv file_path
    employees = []
    CSV.foreach file_path, headers: true, header_converters: :symbol do |row|
      employees << Employee.new(row[:employee_name], row[:department], row[:manager], row[:salary])
    end
    new employees
  end


  def structure_by property_name
    if property_name.to_sym == :manager
      structure_by_manager
    else
      raise ArgumentError.new("Allowed value is manager only for now")
    end
  end


  def group_by property_name
    property_name = property_name.to_sym
    unless [:department, :salary].include? property_name
      raise ArgumentError.new("Allowed values are department and salary")
    end

    grouped = {}
    @records.each do |rec|
      value = rec.send property_name
      grouped[value] ||= []
      grouped[value] << rec
    end
    grouped
  end


private

  def structure_by_manager top_manager=nil, level=0
    records_with_level = []
    @records.select {|employee| employee.manager_name == top_manager }.each do |employee|
      records_with_level << EmployeeWithLevel.new(employee, level)
      records_with_level += structure_by_manager(employee.name, level + 1) if employee.name
    end

    if level == 0
      skipped = @records - records_with_level.map(&:employee)
      records_with_level += skipped.map {|employee| EmployeeWithLevel.new employee }
    end

    records_with_level
  end

end
