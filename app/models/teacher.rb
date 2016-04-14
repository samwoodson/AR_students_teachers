class Teacher < ActiveRecord::Base

  has_many :students 

  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }, presence: true, uniqueness: true
  validate :valid_retirement
  after_save :check_for_retirement

  def days_employed
    retirement_date ? retirement_date - hire_date : Date.today - hire_date
  end 

  private
    def valid_retirement
      if hire_date && retirement_date
        errors.add(:retirement_date, "retirement has to be after hire date!") if retirement_date < hire_date
        errors.add(:retirement_date, "retirement can't be in the future!") if retirement_date > Date.today
      end
    end

    def check_for_retirement
      if retirement_date
        students.each {|student| student.update(teacher_id: nil)}
      end
    end

end
