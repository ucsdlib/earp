# frozen_string_literal: true

json.array! @recognitions, partial: 'recognitions/recognition', as: :recognition
