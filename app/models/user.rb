class User < ApplicationRecord
  enum role: [:user, :associate, :admin]
  after_initialize :set_default_role, :if => :new_record?
  has_many :visits

  def set_default_role
    self.role ||= :user
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
end
