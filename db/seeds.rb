# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# db/seeds.rb
require 'faker'

# Definição de quantidades:
NUM_CATEGORIES    = 22
NUM_CUSTOMERS     = 1200
NUM_PRODUCTS      = 1000
NUM_ORDERS        = 1500
NUM_ORDER_ITEMS   = 5000
NUM_REVIEWS       = 5000  # total de reviews desejado

# ---------------------------
# 1) Criação de CATEGORIES
# ---------------------------
puts "==> Limpando dados existentes..."
Review.delete_all
OrderItem.delete_all
Order.delete_all
Product.delete_all
Customer.delete_all
Category.delete_all

puts "==> Criando #{NUM_CATEGORIES} categorias..."
# Para evitar duplicados, podemos usar um set ou lista e Faker com unique
Faker::UniqueGenerator.clear
category_names = []
NUM_CATEGORIES.times do
  # Loop para encontrar um nome único
  name = Faker::Commerce.unique.department(max: 1)
  category_names << name
end

category_records = category_names.map do |name|
  Category.create!(name: name)
end

puts "Categorias criadas: #{category_records.count}"

# ---------------------------
# 2) Criação de CUSTOMERS
# ---------------------------
puts "==> Criando #{NUM_CUSTOMERS} clientes..."
Faker::UniqueGenerator.clear

customer_records = []
NUM_CUSTOMERS.times do
  customer_records << Customer.create!(
    first_name:  Faker::Name.first_name,
    last_name:   Faker::Name.last_name,
    email:       Faker::Internet.unique.email,
    phone:       Faker::PhoneNumber.cell_phone_in_e164,
    country:     Faker::Address.country,
    created_at:  Faker::Time.backward(days: 365, period: :morning)
  )
end

puts "Clientes criados: #{customer_records.count}"

# Insere somente até aqui, por enquanto
exit

# ---------------------------
# 3) Criação de PRODUCTS
# ---------------------------
puts "==> Criando #{NUM_PRODUCTS} produtos..."
product_records = []
NUM_PRODUCTS.times do
  product_records << Product.create!(
    name:        Faker::Commerce.product_name,
    category:    category_records.sample,
    price:       Faker::Commerce.price(range: 10.0..5000.0),
    stock:       rand(10..500),
    created_at:  Faker::Time.backward(days: 365, period: :morning)
  )
end

puts "Produtos criados: #{product_records.count}"

# ---------------------------
# 4) Criação de ORDERS
# ---------------------------
puts "==> Criando #{NUM_ORDERS} pedidos..."
order_records = []
status_list = %w[pending paid shipped canceled]

NUM_ORDERS.times do
  order_records << Order.create!(
    customer:   customer_records.sample,
    order_date: Faker::Time.backward(days: 365, period: :morning),
    status:     status_list.sample
  )
end

puts "Pedidos criados: #{order_records.count}"

# ---------------------------
# 5) Criação de ORDER_ITEMS
# ---------------------------
puts "==> Criando #{NUM_ORDER_ITEMS} itens de pedido..."
NUM_ORDER_ITEMS.times do
  OrderItem.create!(
    order:      order_records.sample,
    product:    product_records.sample,
    quantity:   rand(1..5),
    unit_price: Faker::Commerce.price(range: 10.0..5000.0)
  )
end

puts "Itens de pedido criados: #{OrderItem.count}"

# ---------------------------
# 6) Criação de REVIEWS
# ---------------------------
puts "==> Criando #{NUM_REVIEWS} reviews..."
# Para garantir que cada produto tenha ao menos 1 review:
reviews_created = 0

product_records.each do |product|
  # Cria pelo menos 1 review obrigatório
  Review.create!(
    product:    product,
    customer:   customer_records.sample,
    rating:     rand(1..5),
    comment:    Faker::Lorem.sentence(word_count: rand(5..15)),
    created_at: Faker::Time.backward(days: 365, period: :morning)
  )
  reviews_created += 1
end

# Agora criamos reviews até atingir 5000 (ou o número que desejar)
while reviews_created < NUM_REVIEWS
  product  = product_records.sample
  customer = customer_records.sample

  Review.create!(
    product:    product,
    customer:   customer,
    rating:     rand(1..5),
    comment:    Faker::Lorem.sentence(word_count: rand(5..15)),
    created_at: Faker::Time.backward(days: 365, period: :morning)
  )

  reviews_created += 1
end

puts "Reviews criados: #{Review.count}"

puts "==> SEED FINALIZADO!"
