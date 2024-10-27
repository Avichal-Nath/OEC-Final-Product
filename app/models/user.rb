# app/models/user.rb
class User < ApplicationRecord
  has_many :orders, dependent: :destroy  # Add this line
  has_many :cart_items, dependent: :destroy
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, presence: true, uniqueness: true
end
