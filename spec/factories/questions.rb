FactoryBot.define do
  factory :question do
    lesson { nil }
    question_type { "MyString" }
    content { "MyText" }
    correct_answer { "MyString" }
    options { "MyText" }
    explanation { "MyText" }
    experience_points { 1 }
    created_at { "2025-09-04 00:13:09" }
    updated_at { "2025-09-04 00:13:09" }
  end
end
