require 'rails_helper'

RSpec.describe User, type: :model do
  include ActiveSupport::Testing::TimeHelpers
  let(:valid_attributes) do
    {
      name: "John Doe",
      email: "john@example.com",
      password: "password123",
      password_confirmation: "password123"
    }
  end

  describe "validations" do
    it "requires email and name" do
      user = User.new(valid_attributes.merge(email: "", name: ""))
      expect(user).not_to be_valid
      expect(user.errors[:email]).to be_present
      expect(user.errors[:name]).to be_present
    end

    it "requires unique email" do
      User.create!(valid_attributes)
      duplicate_user = User.new(valid_attributes)
      expect(duplicate_user).not_to be_valid
      expect(duplicate_user.errors[:email]).to include("has already been taken")
    end

    it "validates email format" do
      user = User.new(valid_attributes.merge(email: "invalid"))
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("is invalid")
    end

    it "validates numeric fields are non-negative" do
      user = User.create!(valid_attributes)
      user.experience_points = -1
      user.current_streak = -1
      user.level = 0
      expect(user).not_to be_valid
    end
  end

  describe "defaults" do
    let(:user) { User.create!(valid_attributes) }

    it "sets default values" do
      expect(user.experience_points).to eq(0)
      expect(user.level).to eq(1)
      expect(user.current_streak).to eq(0)
      expect(user.last_activity_date).to eq(Date.current)
    end
  end

  describe "#add_experience!" do
    let(:user) { User.create!(valid_attributes) }

    it "adds experience points and updates level" do
      user.add_experience!(150)
      expect(user.experience_points).to eq(150)
      expect(user.level).to eq(2) # sqrt(150/100) + 1 = 2.22 -> 2
    end

    it "updates last_activity_date" do
      travel_to 1.day.ago do
        user.update!(last_activity_date: Date.current)
      end

      user.add_experience!(50)
      expect(user.last_activity_date).to eq(Date.current)
    end
  end

  describe "#update_streak!" do
    let(:user) { User.create!(valid_attributes) }

    context "when last activity was yesterday" do
      it "increments streak" do
        user.update!(last_activity_date: Date.current - 1.day, current_streak: 5)
        user.update_streak!
        expect(user.current_streak).to eq(6)
      end
    end

    context "when last activity was not yesterday" do
      it "resets streak to 1" do
        user.update!(last_activity_date: Date.current - 3.days, current_streak: 10)
        user.update_streak!
        expect(user.current_streak).to eq(1)
      end
    end

    context "when last activity was today" do
      it "keeps current streak" do
        user.update!(current_streak: 7)
        user.update_streak!
        expect(user.current_streak).to eq(7)
      end
    end
  end
end
