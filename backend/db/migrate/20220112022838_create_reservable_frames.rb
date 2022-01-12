class CreateReservableFrames < ActiveRecord::Migration[6.1]
  def change
    create_table :reservable_frames do |t|
      t.references :expert
      t.datetime :start_at
      t.timestamps
    end
  end
end
