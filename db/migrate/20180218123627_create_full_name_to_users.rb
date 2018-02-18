class CreateFullNameToUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :full_name_to_users do |t|
    	add_column :users, :full_name, :string, null: true
    end
  end
end
