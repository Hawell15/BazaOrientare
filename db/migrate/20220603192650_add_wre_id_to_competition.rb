class AddWreIdToCompetition < ActiveRecord::Migration[7.0]
  def change
    add_column :competitions, :wre_id, :string
  end
end
