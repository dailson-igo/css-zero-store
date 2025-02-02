class Category < ApplicationRecord
  has_many :products

  # Exemplo: validações de unicidade
  validates :name, presence: true, uniqueness: true
end
