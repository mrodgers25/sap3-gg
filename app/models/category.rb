class Category < ApplicationRecord
  has_ancestry
  has_many :places
  validates :name, :reference, presence: true 
  before_save :titleize_name

  scope :places, -> { where(:reference => "place").order(:name) }
 
  def titleize_name
    self.name = self.name.titleize
  end

end
