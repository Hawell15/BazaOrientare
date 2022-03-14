class CreateClubs < ActiveRecord::Migration[7.0]
  def change
    create_table :clubs do |t|
      t.string :clubs_name
      t.string :territory
      t.string :representative
      t.string :email
      t.string :phone

      t.timestamps
    end
  end
end
