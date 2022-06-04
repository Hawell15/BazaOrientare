class AddWreIdToRunner < ActiveRecord::Migration[7.0]
  def change
    add_column :runners, :wre_id, :string
  end
end
