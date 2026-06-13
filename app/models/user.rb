class User < ApplicationRecord
  after_create_commit { UserMailer.welcome_email(self).deliver_later unless admin? }

  has_many :cart_items, dependent: :destroy
  has_many :orders,     dependent: :nullify
  has_many :wish_lists

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable
end
