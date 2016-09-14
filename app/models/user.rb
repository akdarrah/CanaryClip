class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :characters
  has_many :character_claims
  has_many :owned_servers, foreign_key: :owner_user_id, class_name: "Server"

  belongs_to :current_character, class_name: "Character"
end
