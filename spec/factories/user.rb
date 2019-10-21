# frozen_string_literal: true
FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@ucsd.edu" }
    sequence(:uid) { |n| "user#{n}" }
    full_name { 'Jane Triton' }
    provider { 'google_oauth2' }
  end
end
