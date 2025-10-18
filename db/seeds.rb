# Create default admin user
unless User.exists?(email: 'admin@example.com')
  User.create!(
    email: 'admin@example.com',
    username: 'admin',
    password: 'password'
  )
  puts "Created admin user"
end

# Create sample categories
['Electronics', 'Clothing', 'Books'].each_with_index do |name, index|
  unless Category.exists?(name: name)
    Category.create!(
      name: name,
      publish: index.even? ? 1 : 0
    )
    puts "Created category: #{name}"
  end
end

# Create sample products
Category.all.each_with_index do |category, cat_index|
  2.times do |prod_index|
    product_name = "Product #{cat_index * 2 + prod_index + 1}"
    unless Product.exists?(name: product_name)
      Product.create!(
        name: product_name,
        category: category,
        publish: 1
      )
      puts "Created product: #{product_name}"
    end
  end
end

puts "\nSeeding completed!"
puts "Users: #{User.count}"
puts "Categories: #{Category.count}"
puts "Products: #{Product.count}"
