# frozen_string_literal: true
FactoryBot.define do
  factory :recognition do
    # TODO: This is currently stored as the employee ID since they may not be in the system
    #       This may be stupid and need a rethink
    sequence(:recognizee) { |n| n }
    library_value { %w[diversity collab innovate flexible service].sample }
    sequence(:description) { |n| "#{n} is so AMAZING!" }

    user
  end
end
