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
        expect(@teacher).to_not be_valid
      end
    end

    it 'should accept valid emails' do
      ['joe@example.com', 'info@bbc.co.uk', 'bugs@facebook.com'].each do |address|
        @teacher.assign_attributes(email: address)
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
  end
end
