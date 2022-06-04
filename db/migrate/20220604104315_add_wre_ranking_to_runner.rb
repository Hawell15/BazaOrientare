class AddWreRankingToRunner < ActiveRecord::Migration[7.0]
  def change
    add_column :runners, :sprint_wre_ranking, :integer
    add_column :runners, :forrest_wre_ranking, :integer
  end
end
