class AddPhonenoToLink < ActiveRecord::Migration[5.0]
  def change
    add_column :links, :phoneno, :string
  end
end
