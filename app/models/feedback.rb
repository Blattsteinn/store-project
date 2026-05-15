class Feedback < ApplicationRecord
    belongs_to :user
    belongs_to :order

    validates :rating, presence: true, numericality: {
        only_integer: true, 
        greater_than: 0,
        less_than_or_equal_to: 5 }

    validates :feedback, presence: true, length: {minimum: 10}
   
end
