class User < ApplicationRecord
  enum role: [:user, :associate, :admin]
  after_initialize :set_default_role, :if => :new_record?
  has_many :visits
  has_many :events, class_name: 'Ahoy::Event'
  accepts_nested_attributes_for :events

  def set_default_role
    self.role ||= :user
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
end
