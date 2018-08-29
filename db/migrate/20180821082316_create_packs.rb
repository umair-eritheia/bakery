class CreatePacks < ActiveRecord::Migration[5.2]
  def change
    create_table :packs do |t|
      t.string :name
      t.integer :pack_quantity
      t.integer :available_quantity
      t.float :price
      t.references :product, foreign_key: true

      t.timestamps
    end
  end
end
