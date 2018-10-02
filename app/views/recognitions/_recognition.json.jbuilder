# frozen_string_literal: true

json.extract! recognition, :id, :recognizee, :library_value,
              :description, :anonymous, :recognizer,
              :created_at, :updated_at
json.url recognition_url(recognition, format: :json)
