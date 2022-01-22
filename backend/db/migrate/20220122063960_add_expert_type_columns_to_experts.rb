class AddExpertTypeColumnsToExperts < ActiveRecord::Migration[6.1]
  def change
    add_column :experts, :expert_type_id, :integer
  end
end
