FactoryBot.define do
  factory :employee do
    sequence(:uid) { |n| "employee#{n}" }
    sequence(:email) { |n| "employee#{n}@ucsd.edu" }
    name { "MyString" }
    active { true }
    sequence(:manager) { |n| "manager#{n}" }
    display_name { "MyString" }
  end

  factory :employee_without_manager, class: "Employee" do
    sequence(:uid) { |n| "employee#{n}" }
    sequence(:email) { |n| "employee#{n}@ucsd.edu" }
    name { "MyString" }
    active { true }
    display_name { "MyString" }
  end
end
