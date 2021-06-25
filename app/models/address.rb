class Address < ApplicationRecord
  geocoded_by :full_address
  after_validation :geocode, if: :address_changed?

  def full_address
    [street_address, locality, region, postal_code, country].compact.split('').flatten.join(', ')
  end

  def address_changed?
    street_address_changed? || locality_changed? || region_changed? || postal_code_changed? || country_changed?
  end
end
