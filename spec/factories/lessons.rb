FactoryBot.define do
  factory :lesson do
    domain { nil }
    title { "Test Lesson" }
    summary { "A brief summary of the lesson" }
    content { "Detailed lesson content goes here" }
    position { 1 }
    created_at { "2025-09-04 00:13:04" }
    updated_at { "2025-09-04 00:13:04" }
  end
end
