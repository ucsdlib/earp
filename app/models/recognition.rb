# frozen_string_literal: true

class Recognition < ApplicationRecord
  validates :recognizee, :library_value, :description, presence: true
end
