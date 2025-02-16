class Category < ApplicationRecord
  has_many :products

  # Exemplo: validações de unicidade
  validates :name, presence: true, uniqueness: true

  def self.ransackable_attributes(auth_object = nil)
    [ "name" ]
  end
end
