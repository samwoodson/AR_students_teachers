require_relative 'spec_helper'

describe Teacher do
  before(:all) do
    raise RuntimeError, "be sure to run 'rake db:migrate' before running these specs" unless ActiveRecord::Base.connection.table_exists?(:teachers)
  end

  context 'validations' do
    before(:each) do
      @teacher = Teacher.new
      @teacher.assign_attributes(
        name: 'Kreay Shawn',
        email: 'kreayshawn@oaklandhiphop.net',
        phone: '(510) 555-1212 x4567',
        address: '999 Last Road'
      )
    end

    it 'should accept valid info' do
      expect(@teacher).to be_valid
    end

    it "shouldn't accept invalid emails" do
      ['XYZ!bitnet', '@.', 'a@b.c'].each do |address|
        @teacher.assign_attributes(email: address)
        @teacher.save
        expect(@teacher).to_not be_valid
      end
    end

    it 'should accept valid emails' do
      ['joe@example.com', 'info@bbc.co.uk', 'bugs@facebook.com'].each do |address|
        @teacher.assign_attributes(email: address)
        @teacher.save
        expect(@teacher).to be_valid
      end
    end

    it "shouldn't allow two teachers with the same email" do
      Teacher.create!(
        email: @teacher.email,
        phone: @teacher.phone
      )
      expect(@teacher).to_not be_valid
    end
  
    it "should update the last student added at field to todays date" do
      @teacher.save
      student = Student.new
      student.assign_attributes(
        first_name: 'Happy',
        last_name: 'Gilmore',
        gender: 'male',
        birthday: Date.new(1970, 9, 1),
        email: 'krwn@oakland.net',
        teacher_id: @teacher.id
      )
      student.save
      @teacher.reload
      expect(@teacher.last_student_added_at).to eq(Date.today)
    end

    it "each teacher should remove teacher_id from their students upon retirement" do
      @teacher.save
      student = Student.new
      student.assign_attributes(
        first_name: 'Happy',
        last_name: 'Gilmore',
        gender: 'male',
        birthday: Date.new(1970, 9, 1),
        email: 'krwn@oakland.net',
        teacher_id: @teacher.id
      )
      student.save
      @teacher.reload
      @teacher.update(retirement_date: Date.today)
      student.reload
      expect(student.teacher_id).to eq(nil)
    end

        it "should give the correct employed days for a current teacher" do
      @teacher.update(hire_date: Date.new(2001,2,3))
      expect(@teacher.days_employed).to eq(Date.today - @teacher.hire_date)
    end

    it "should give the correct employed days for a previously retired teacher" do
        @teacher.update(hire_date: Date.new(2001,2,3), retirement_date: Date.new(2012,2,9))
        expect(@teacher.days_employed).to eq(@teacher.retirement_date - @teacher.hire_date)   
    end

  end
end
