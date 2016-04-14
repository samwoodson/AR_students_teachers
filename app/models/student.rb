class Student < ActiveRecord::Base
  # implement your Student model here
  belongs_to :teacher
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }, presence: true, uniqueness: true
  validates :age, numericality: { greater_than: 3 }

  def name
    "#{first_name} #{last_name}"
  end

  def age
    now = Date.today
    now.year - self.birthday.year - ((now.month > self.birthday.month || (now.month == self.birthday.month && now.day >= self.birthday.day)) ? 0 : 1)
  end



end
