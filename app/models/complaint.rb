class Complaint < ApplicationRecord
    validates :name, presence: true
    validates :email, presence: true
    validates :product_name, presence: true
    validates :product_link, presence: true
    validates :complaint_text, presence: true
end