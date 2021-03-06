# frozen_string_literal: true

require 'csv'

# StatisticsHelper methods
module StatisticsHelper
  # Given result set of Recognitions between a date range, generate a csv for an administrator
  # @param results
  # @return [String] csv of results
  def generate_csv(results)
    attributes = %w[Reconizee Recognizer Value Description Anonymous Opted-Out Submitted]

    CSV.generate(headers: true) do |csv|
      csv << attributes

      results.each do |recognition|
        csv << recognition_row(recognition)
      end
    end
  end

  def recognition_row(recognition)
    nominee = recognition.employee.display_name
    nominator = recognition.user.full_name
    value = LIBRARY_VALUES[recognition.library_value]
    description = recognition.description
    anonymous = recognition.anonymous
    suppressed = recognition.suppressed
    submitted = recognition.created_at
    [nominee, nominator, value, description, anonymous, suppressed, submitted]
  end
end
