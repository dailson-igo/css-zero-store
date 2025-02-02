class Customer < ApplicationRecord
  has_many :orders
  has_many :reviews

  # Exemplo: validação de e-mail único
  validates :email, presence: true, uniqueness: true

  def full_name
    [ first_name, last_name ].compact.join(" ").presence
  end
end
