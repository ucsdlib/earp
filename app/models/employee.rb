# frozen_string_literal: true

# Employee - populated from LDAP bulk query
# Should never be edited locally
class Employee < ApplicationRecord
  has_many :recognitions, dependent: :destroy

  validates :uid, :email, :manager, :display_name, :name, presence: true

  # Given an Net::LDAP::Entry extract and populate an Employee record
  # using the cn/uid as the unique key
  # @param [Net::LDAP::Entry] employee_info
  # rubocop:disable Metrics/AbcSize
  def self.populate_from_ldap(employee_info)
    e = find_or_initialize_by(uid: employee_info.cn.first)
    e.display_name = employee_info.displayname.first
    e.email = employee_info.mail.first
    e.manager = employee_info.manager.first
    e.name = "#{employee_info.givenName.first} #{employee_info.sn.first}"
    e.save
    # try saving thumbnail as well
    cache_employee_photo(employee_info)
  end
  # rubocop:enable Metrics/AbcSize

  # Given an Net::LDAP::Entry store the employee photo if available
  # @param [Net::LDAP::Entry] employee_info
  def self.cache_employee_photo(employee_info)
    return unless employee_info.respond_to?(:thumbnailphoto)

    image_path = Rails.root.join('app', 'assets', 'images', 'photos', "#{employee_info.cn.first}.jpg")
    IO.write(image_path.to_s, employee_info.thumbnailphoto.first, mode: 'wb')
  end
end
