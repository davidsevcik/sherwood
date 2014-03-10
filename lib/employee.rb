Employee = Struct.new(:name, :department, :manager_name, :salary) do
  def to_s
    "#{name || 'missing name'} (#{department || 'no department'})"
  end
end
