class Developer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :project
  has_and_belongs_to_many :projects
  has_and_belongs_to_many :tasks

  validates :name,
    presence: true,
    format: {with: /\A[a-zA-Z]+\z/, message: "only allows letters"}
  validates :lastname,
    presence: true,
    format: {with: /\A[a-zA-Z]+\z/, message: "only allows letters"}
end
