# frozen_string_literal: true

# RecognitionsHelper
module RecognitionsHelper
  def library_values
    # helper for form needs to be [label, value]
    LIBRARY_VALUES.to_a.map { |entry| [entry[1], entry[0]] }
  end
end
