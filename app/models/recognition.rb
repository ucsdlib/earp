# frozen_string_literal: true

# Recognition
class Recognition < ApplicationRecord
  belongs_to :user
  belongs_to :employee

  validates :library_value, :description, presence: true
end
