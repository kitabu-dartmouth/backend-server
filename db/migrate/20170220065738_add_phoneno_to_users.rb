class AddPhonenoToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :phoneno, :string
    add_index :users, :phoneno, unique: true
  end
end
