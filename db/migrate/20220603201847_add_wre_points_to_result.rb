class AddWrePointsToResult < ActiveRecord::Migration[7.0]
  def change
    add_column :results, :wre_points, :integer
  end
end
