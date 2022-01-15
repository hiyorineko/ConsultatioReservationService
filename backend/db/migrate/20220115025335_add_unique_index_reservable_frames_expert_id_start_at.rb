class AddUniqueIndexReservableFramesExpertIdStartAt < ActiveRecord::Migration[6.1]
  def change
    add_index :reservable_frames, [:expert_id, :start_at], unique: true
  end
end
