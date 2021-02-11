class User < ApplicationRecord
	has_many :shared_location_registers, dependent: :destroy
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  attr_writer :login

  validates :username, :presence => true, :uniqueness => { :case_sensitive => false } 

  def login
    @login || self.username || self.email
  end
  
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if username = conditions.delete(:login)
      where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { :value => username }]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end

  def self.fetch_all_users(current_user_id)
    users_list_obj = self.where("id != #{ current_user_id }") rescue []
    response_arr = []
    users_list_obj.each do |user|
      _inner_hash = {}
      _inner_hash["id"] = user.id
      _inner_hash["username"] = user.username
      _inner_hash["email"] = user.email
      _inner_hash["show_button"] = "<input class='btn-cust' type='button' value='Show' onclick='show_user_shared_location(\"#{ user.username }\")' >"
      response_arr << _inner_hash
    end
    return response_arr
  end
end