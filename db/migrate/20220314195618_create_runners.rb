class CreateRunners < ActiveRecord::Migration[7.0]
  def change
    create_table :runners do |t|
      t.string :runner_name
      t.string :surname
      t.date :dob
      t.references :category, null: false, foreign_key: true
      t.references :club, null: false, foreign_key: true
      t.string :gender
      t.date :category_valid

      t.timestamps
    end
  end
end
