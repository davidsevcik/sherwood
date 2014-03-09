require 'CSV'

Employee = Struct.new(:name, :department, :manager_name) do
  def to_s
    "#{name || 'missing name'} (#{department || 'no department'})"
  end
end


def read_csv file_path
  employees = []
  CSV.foreach file_path, headers: true, header_converters: :symbol do |row|
    employees << Employee.new(row[:employee_name], row[:department], row[:manager])
  end
  employees
end



def print_structure employees, top_manager=nil, level=0, processed=[]
  employees.select {|employee| employee.manager_name == top_manager }.each do |employee|
    processed << employee
    print '  ' * (level - 1), "\u2517 " if level > 0
    puts employee
    print_structure employees, employee.name, level + 1, processed if employee.name
  end

  if level == 0 and !(employees - processed).empty?
    puts "\nWith missing manager record:"
    (employees - processed).each do |employee|
      puts "#{employee} - manager #{employee.manager_name}"
    end
  end
end


if ARGV[0]
  print_structure read_csv(ARGV[0])
else
  puts "Plese provide path to a CSV file"
end
