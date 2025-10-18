class CreateInitialTables < ActiveRecord::Migration[8.0]
  def change
    enable_extension "pgcrypto" unless extension_enabled?("pgcrypto")

    create_table :users, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.string :email, null: false
      t.string :username, null: false
      t.string :password_digest, null: false
      t.timestamps
    end
    add_index :users, :email, unique: true
    add_index :users, :username, unique: true

    create_table :categories, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.string :name, null: false
      t.integer :publish, default: 0, null: false
      t.timestamps
    end

    create_table :products, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.string :name, null: false
      t.uuid :category_id
      t.integer :publish, default: 0, null: false
      t.timestamps
      t.index :category_id
    end
    add_foreign_key :products, :categories
  end
end
