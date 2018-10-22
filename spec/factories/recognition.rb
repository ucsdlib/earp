# frozen_string_literal: true
FactoryBot.define do
  factory :recognition do
    library_value { %w[diversity collab innovate flexible service].sample }
    sequence(:description) { |n| "#{n} is so AMAZING!" }
  end
end
