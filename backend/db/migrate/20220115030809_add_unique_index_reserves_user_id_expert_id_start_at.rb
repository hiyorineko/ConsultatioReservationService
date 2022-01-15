class AddUniqueIndexReservesUserIdExpertIdStartAt < ActiveRecord::Migration[6.1]
  def change
    add_index :reserves, [:user_id, :expert_id, :start_at], unique: true
  end
end
