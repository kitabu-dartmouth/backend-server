class ChangeTableLinks < ActiveRecord::Migration[5.0]
  def change
      remove_column :links, :type
      add_column :links, :typep, :boolean
  end
end
