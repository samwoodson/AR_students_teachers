class Student < ActiveRecord::Base
  # implement your Student model here
  belongs_to :teacher
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }, presence: true, uniqueness: true
  validates :age, numericality: { greater_than: 3 }
  after_save :add_date_to_teacher, if: :teacher


  def name
    "#{first_name} #{last_name}"
  end

  def age
    now = Date.today
    now.year - self.birthday.year - ((now.month > self.birthday.month || (now.month == self.birthday.month && now.day >= self.birthday.day)) ? 0 : 1)
  end

  private 
    def add_date_to_teacher
      teacher.touch(:last_student_added_at)
    end

end
