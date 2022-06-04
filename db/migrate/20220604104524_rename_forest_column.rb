class RenameForestColumn < ActiveRecord::Migration[7.0]
  def change
    rename_column :runners, :forrest_wre_ranking, :forest_wre_ranking

  end
end
