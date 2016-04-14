class AddTeacherFunctions < ActiveRecord::Migration

  def change
    change_table :teachers do |t|
      t.date :last_student_added_at
    end
  end

end
