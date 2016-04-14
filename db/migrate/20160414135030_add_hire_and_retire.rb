class AddHireAndRetire < ActiveRecord::Migration
  
  def change
    change_table :teachers do |t|
      t.date :hire_date 
      t.date :retirement_date
    end
  end

end