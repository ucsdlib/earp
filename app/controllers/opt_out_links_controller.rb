# frozen_string_literal: true

# OptOutLinksController
class OptOutLinksController < ApplicationController
  # GET /optout
  def optout
    return unless optout_params[:key]

    optout_record = OptOutLink.find_by(key: optout_params[:key])
    notice = ''
    if optout_record.nil?
      notice = 'No recognitions matched your key'
    else
      complete_optout(optout_record)
      notice = 'Your recogntion has been suppressed from public view'
    end
    redirect_to recognitions_url, notice: notice
  end

  private

  # Finish the optout process by suppressing the recognition and removing the optoutlink
  def complete_optout(optout_record)
    recognition_record = Recognition.find_by(id: optout_record.recognition_id)
    recognition_record.suppressed = true
    recognition_record.save!
    optout_record.delete
  end

  def optout_params
    params.permit(:key)
  end
end
