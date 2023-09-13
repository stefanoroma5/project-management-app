class Developer < ApplicationRecord
  validates :name, presence: true
  validates :lastname, presence: true
  validates :email, presence: true
  validates :password, presence: true
end
