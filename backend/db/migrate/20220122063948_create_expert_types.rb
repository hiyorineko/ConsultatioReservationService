class CreateExpertTypes < ActiveRecord::Migration[6.1]
  def change
    create_table :expert_types do |t|
      t.text :name
    end
  end
end
