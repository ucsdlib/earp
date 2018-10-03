# frozen_string_literal: true

# Recognition
class Recognition < ApplicationRecord
  belongs_to :user
  validates :recognizee, :library_value, :description, presence: true
end
