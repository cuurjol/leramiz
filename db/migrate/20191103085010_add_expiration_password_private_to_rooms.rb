class AddExpirationPasswordPrivateToRooms < ActiveRecord::Migration[5.2]
  def change
    add_column :rooms, :expiration, :integer
    add_column :rooms, :password, :string
    add_column :rooms, :is_private, :boolean, default: false
  end
end
