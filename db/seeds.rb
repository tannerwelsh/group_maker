require 'csv'

STUDENT_FILE = File.dirname(__FILE__) + '/../lib/assets/students.csv'

# Generate students
CSV.read(STUDENT_FILE).each_with_index do |row, index|
  next if index == 0
  User.create! name: "#{row[0]} #{row[1]}", email: row[2], password: "mvclover"
end

# Create admin account
admin = User.create! name: "admin", email: "tanner@devbootcamp.com", password: "bananas"
admin.update_attribute(:role, "admin")