# encoding: utf-8

require 'rails_helper'

RSpec.describe RecognitionMailer do
  let!(:manager) { FactoryBot.create(:employee) }
  let(:recognition) { FactoryBot.build_stubbed(:recognition,
                                                 user: user,
                                                 created_at: Time.parse('2018-10-01'),
                                                 description: 'in report',
                                                 employee: employee) }
  let(:employee) { FactoryBot.create(:employee) }
  let(:user) { FactoryBot.build_stubbed(:user) }
  let(:email) {RecognitionMailer.email(recognition)}
  before do
    mock_email_credential
  end
      
  it 'renders the subject' do
    expect(email.subject).to eql("You have been recognized!")
  end

  it 'renders the receiver email' do
    expect(email.to).to eql([employee.email, manager.email])
  end
  
  it 'renders the sender email' do
    expect(email.from).to eql(['developer@ucsd.edu'])
  end
 
  it 'assigns recognition name, library value, and description' do
    expect(email.body.encoded).to match("Dear #{recognition.employee.name},")
    expect(email.body.encoded).to match("#{LIBRARY_VALUES[recognition.library_value]}")
    expect(email.body.encoded).to match("#{recognition.description}")
  end 

  it 'assigns recognition url' do
    url = "/recognitions/#{recognition.id}"
    expect(email.body.encoded).to match(url)
  end
      
end
