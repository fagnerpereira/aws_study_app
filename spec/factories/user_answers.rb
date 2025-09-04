FactoryBot.define do
  factory :user_answer do
    user { nil }
    question { nil }
    selected_answer { "MyString" }
    correct { false }
    answered_at { "2025-09-04 00:13:20" }
    created_at { "2025-09-04 00:13:20" }
    updated_at { "2025-09-04 00:13:20" }
  end
end
