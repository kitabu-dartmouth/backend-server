class AddRegidToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :regid, :text
  end
end
