class Expert < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  has_many :reserve
  has_many :reservable_frame

  def get_image_path
    image_path.presence || ""
  end
end
