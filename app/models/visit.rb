class Visit < ApplicationRecord
  belongs_to :user, polymorphic: true
end
