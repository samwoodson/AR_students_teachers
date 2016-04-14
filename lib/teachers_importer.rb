require 'faker'
class TeachersImporter

  def import
    field_names = ['name', 'email', 'phone', 'address']
    puts "Importing fake teachers"
    failure_count = 0
    9.times do
      data = [Faker::Name.name, Faker::Internet.email, Faker::PhoneNumber.phone_number, Faker::Address.street_address]
      attribute_hash = Hash[field_names.zip(data)]
      begin
        Teacher.create!(attribute_hash)
        print'.'
      rescue ActiveRecord::UnknownAttributeError
        failure_count += 1
        print '!'
      ensure
        STDOUT.flush
      end
    end
  failures = failure_count > 0 ? "(failed to create #{failure_count} teacher records)" : ''
  puts "\nDONE #{failures}\n\n"
  end

end

