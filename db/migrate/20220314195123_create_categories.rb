class CreateCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :categories do |t|
      t.string :category_name
      t.string :full_name
      t.float :points

      t.timestamps
    end
  end
end
