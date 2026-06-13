class SupportMessage < ApplicationRecord
  belongs_to :order, optional: true

  validates :email, presence: true
  validates :message, presence: true, length: {minimum: 10}
  validates :title, presence: true
end
