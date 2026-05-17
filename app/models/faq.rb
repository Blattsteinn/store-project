class Faq < ApplicationRecord
    validates :answer, presence: true
    validates :question, presence: true
end
