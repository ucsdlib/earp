# frozen_string_literal: true

require 'csv'

module StatisticsHelper
  # Given result set of Recognitions between a date range, generate a csv for an administrator
  # @param results
  # @return [String] csv of results
  def generate_csv(results)
    attributes = %w[Reconizee Recognizer Value Anonymous Submitted]

    CSV.generate(headers: true) do |csv|
      csv << attributes

      results.each do |recognition|
        nominee = recognition.employee.display_name
        nominator = recognition.user.full_name
        value = recognition.library_value
        anonymous = recognition.anonymous
        submitted = recognition.created_at
        csv << [nominee, nominator, value, anonymous, submitted]
      end
    end
  end
end
