class CreateReserves < ActiveRecord::Migration[6.1]
  def change
    create_table :reserves do |t|
      t.references :user
      t.references :expert
      t.datetime :start_at
      t.text :user_comment
      t.timestamps
    end
  end
end
