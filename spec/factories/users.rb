FactoryBot.define do
  factory :user do
    email { "MyString" }
    password_digest { "MyString" }
    name { "MyString" }
    experience_points { 1 }
    level { 1 }
    current_streak { 1 }
    last_activity_date { "2025-09-04" }
    created_at { "2025-09-04 00:12:54" }
    updated_at { "2025-09-04 00:12:54" }
  end
end
