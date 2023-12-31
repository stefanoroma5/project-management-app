class Developer < ApplicationRecord
  validates :name,
    presence: true,
    format: {with: /\A[a-zA-Z]+\z/, message: "only allows letters"}
  validates :lastname,
    presence: true,
    format: {with: /\A[a-zA-Z]+\z/, message: "only allows letters"}
  validates :email,
    presence: true
  validates :password,
    presence: true,
    length: {minimum: 8}

  validate :password_lower_case, :password_uppercase, :password_special_char, :password_contains_number

  def password_uppercase
    return if !!password&.match(/\p{Upper}/)
    errors.add :password, " must contain at least 1 uppercase "
  end

  def password_lower_case
    return if !!password&.match(/\p{Lower}/)
    errors.add :password, " must contain at least 1 lowercase "
  end

  def password_special_char
    special = "?<>',?[]}{=-)(*&^%$#`~{}!"
    regex = /[#{special.gsub(/./) { |char| "\\#{char}" }}]/
    return if password&.match?(regex)
    errors.add :password, " must contain special character"
  end

  def password_contains_number
    return if password && password.count("0-9") > 0
    errors.add :password, " must contain at least one number"
  end
end
