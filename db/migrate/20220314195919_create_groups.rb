class CreateGroups < ActiveRecord::Migration[7.0]
  def change
    create_table :groups do |t|
      t.string :group_name
      t.string :clasa
      t.float :rang
      t.references :competition, null: false, foreign_key: true

      t.timestamps
    end
  end
end
