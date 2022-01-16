class ChangeImagePathColumnToUserImageExperts < ActiveRecord::Migration[6.1]
  def change
    rename_column :experts, :image_path, :user_image
  end
end
