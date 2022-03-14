class CreateCompetitions < ActiveRecord::Migration[7.0]
  def change
    create_table :competitions do |t|
      t.string :competition_name
      t.date :date
      t.string :location
      t.string :country
      t.string :distance_type

      t.timestamps
    end
  end
end
