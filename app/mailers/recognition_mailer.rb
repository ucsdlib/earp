# frozen_string_literal: true

# Sends a recognition email
class RecognitionMailer < ApplicationMailer
  def email(recognition)
    @recognition = recognition
    opt_out_key(recognition)
    mail(to: "#{@recognition.employee.email},#{manager_email(@recognition.employee.manager)}",
         from: Rails.application.credentials.email[:sender],
         bcc: Rails.application.credentials.email[:bcc],
         subject: 'You have been recognized!')
  end

  def opt_out_key(recognition)
    optout_obj = OptOutLink.where(recognition_id: recognition.id).first
    @key = optout_obj ? optout_obj.key : ''
  end

  def manager_email(manager_dn)
    uid = manager_dn.split(',').first.gsub('CN=', '')
    manager = Employee.find_by(uid: uid)
    return manager.email if manager
  end
end
