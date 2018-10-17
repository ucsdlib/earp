# frozen_string_literal: true
FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "person#{n}@ucsd.edu" }
    sequence(:uid) { |n| n }
    full_name { 'Jane Triton' }
    provider { 'shibboleth' }

    # future idea for adding Roles
    # factory :admin do
    #   roles { [Role.where(name: "admin").first_or_create] }
    # end
  end
end
