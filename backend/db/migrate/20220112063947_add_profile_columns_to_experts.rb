class AddProfileColumnsToExperts < ActiveRecord::Migration[6.1]
  def change
    add_column :experts, :name, :string
    add_column :experts, :profile, :text
    add_column :experts, :image_path, :string
  end
end
