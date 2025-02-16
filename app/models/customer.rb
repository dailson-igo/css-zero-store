class Customer < ApplicationRecord
  has_many :orders
  has_many :reviews

  # Exemplo: validação de e-mail único
  validates :email, presence: true, uniqueness: true

  def self.ransackable_attributes(auth_object = nil)
    [ "country", "created_at", "email", "first_name", "id", "last_name", "phone", "updated_at" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "orders", "reviews" ]
  end

  def full_name
    [ first_name, last_name ].compact.join(" ").presence
  end
end
