# frozen_string_literal: true

# Recognition
class Recognition < ApplicationRecord
  validates :recognizee, :library_value, :description, presence: true
end
