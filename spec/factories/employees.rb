FactoryBot.define do
  factory :employee do
    sequence(:uid) { |n| "employee#{n}" }
    sequence(:email) { |n| "employee#{n}@ucsd.edu" }
    name { "MyString" }
    manager { "MyString" }
    display_name { "MyString" }
  end
end
