# frozen_string_literal: true

# RecognitionsHelper
module RecognitionsHelper
  include Pagy::Frontend

  def library_values
    # helper for form needs to be [label, value]
    LIBRARY_VALUES.to_a.map { |entry| [entry[1], entry[0]] }
  end

  #---
  # Reformat date string to fancy pants sentence (show view)
  #---
  def pretty_date(date)
    date = Date.parse(date.to_s)
    date = date.strftime("Given on the #{date.day.ordinalize} day of %B %Y")
    date
  end

  #---
  # Reformat "Lastname, Firstanme" to "Firstname Lastname" (show view)
  #---
  def pretty_name(name)
    if name.count(',') == 1
      name = name.split(',', 2)
      name = name[1] + ' ' + name[0]
    end
    name
  end
end
