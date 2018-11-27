# frozen_string_literal: true

require 'net/http'

# RecognitionsHelper
module RecognitionsHelper
  def library_values
    # helper for form needs to be [label, value]
    LIBRARY_VALUES.to_a.map { |entry| [entry[1], entry[0]] }
  end

  def url_exist?(url_string)
    uri = URI.parse(url_string)
    Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
      http.request_head(uri.path).is_a?(Net::HTTPSuccess)
    end
  end
end
