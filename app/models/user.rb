class User < ApplicationRecord
  after_create_commit { UserMailer.welcome_email(self).deliver_later }
  
  has_many :cart_items, dependent: :destroy
  has_many :orders,     dependent: :nullify

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
