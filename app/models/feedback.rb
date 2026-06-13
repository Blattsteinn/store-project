class Feedback < ApplicationRecord
    belongs_to :order

    validates :rating, presence: true, numericality: {
        only_integer: true,
        greater_than: 0,
        less_than_or_equal_to: 5 }

    validates :feedback, presence: true, length: { minimum: 5, maximum: 255 }
    validates :order, uniqueness: true
end
