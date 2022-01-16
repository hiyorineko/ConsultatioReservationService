class ChangeImagePathColumnToUserImageUsers < ActiveRecord::Migration[6.1]
  def change
    rename_column :users, :image_path, :user_image
  end
end
