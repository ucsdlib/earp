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
    if optout_obj
      @key = optout_obj.key
    else
      @key = Digest::SHA1.bubblebabble(recognition.id.to_s + Time.zone.now.to_s)
      OptOutLink.new(key: @key, recognition_id: recognition.id, expires: 6.months.from_now).save
    end
  end

  def manager_email(manager_dn)
    uid = manager_dn.split(',').first.gsub('CN=', '')
    manager = Employee.find_by(uid: uid)
    return manager.email if manager
  end
end
