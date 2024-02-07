class Developer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable

  has_one :project
  has_many :developer_projects
  has_many :projects, through: :developer_projects
  has_many :developer_tasks
  has_many :tasks, through: :developer_tasks

  validates :name,
    presence: true,
    format: {with: /\A[a-zA-Z]+\z/, message: "only allows letters"}

  validates :lastname,
    presence: true,
    format: {with: /\A[a-zA-Z]+\z/, message: "only allows letters"}

  validates :email,
    presence: true

  validates :encrypted_password,
    presence: true,
    length: {minimum: 8}

  validate :password_lower_case, :password_uppercase, :password_special_char, :password_contains_number

  def password_uppercase
    return if !!encrypted_password&.match(/\p{Upper}/)
    errors.add :encrypted_password, " must contain at least 1 uppercase "
  end

  def password_lower_case
    return if !!encrypted_password&.match(/\p{Lower}/)
    errors.add :encrypted_password, " must contain at least 1 lowercase "
  end

  def password_special_char
    special = "?<>',?[]}{=-)(*&^%$#`~{}!"
    regex = /[#{special.gsub(/./) { |char| "\\#{char}" }}]/
    return if encrypted_password&.match?(regex)
    errors.add :encrypted_password, " must contain special character from ?<>',?[]}{=-)(*&^%$#`~{}!"
  end

  def password_contains_number
    return if encrypted_password && encrypted_password.count("0-9") > 0
    errors.add :encrypted_password, " must contain at least one number"
  end

  scope :recent, ->(*args) {
    where("created_at > ?",
      (args.first || 2.weeks.ago))
  }

  scope :collaborators, ->(*args) {Developer.joins(:developer_projects).where("developer_projects.project_id = ?", args.first)}
end
