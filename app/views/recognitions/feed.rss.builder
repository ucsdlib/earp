# frozen_string_literal: true

xml.instruct! :xml, version: '1.0'
xml.rss version: '2.0' do
  xml.channel do
    xml.title 'High Five!'
    xml.description 'Employee recognition program for the UC San Diego Library'
    xml.link root_url

    @recognitions.each do |recognition|
      xml.item do
        xml.title "#{recognition.employee.name}
                  was recognized for #{LIBRARY_VALUES[recognition.library_value]}!"
        xml.description recognition.description
        xml.pubDate recognition.created_at.to_s(:rfc822)
        xml.link recognition_url(recognition)
        xml.guid recognition_url(recognition)
      end
    end
  end
end
