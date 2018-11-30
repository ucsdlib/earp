FactoryBot.define do
  factory :employee do
    sequence(:uid) { |n| "employee#{n}" }
    sequence(:email) { |n| "employee#{n}@ucsd.edu" }
    name { "MyString" }
    active { true }
    sequence(:manager) { |n| "CN=employee#{n-1},OU=Users,OU=University Library,DC=AD,DC=UCSD,DC=EDU" }
    display_name { "MyString" }
  end
end
