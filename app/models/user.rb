class User < ApplicationRecord
  has_many :visits
  has_and_belongs_to_many :stories

  enum role: [:user, :associate, :admin]
  after_initialize :set_default_role, if: :new_record?

  def set_default_role
    self.role ||= :user
  end

  def is_role?(role_to_check)
    role == role_to_check.to_s
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
end
