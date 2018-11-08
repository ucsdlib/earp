# frozen_string_literal: true

# Sends a recognition email
class RecognitionMailer < ApplicationMailer
  def email(recognition)
    @recognition = recognition
    manager_email = Ldap::Queries.manager_details(@recognition.employee.manager)[:email]
    opt_out_key(recognition)
    mail(to: "#{@recognition.employee.email},#{manager_email}",
         from: Rails.application.credentials.email[:sender],
         bcc: Rails.application.credentials.email[:bcc],
         subject: 'You have been recognized!')
  end

  def opt_out_key(recognition)
    optout_obj = OptOutLink.where(recognition_id: recognition.id).first
    @key = optout_obj ? optout_obj.key : ''
  end
end
