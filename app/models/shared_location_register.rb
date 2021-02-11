class SharedLocationRegister < ApplicationRecord
	belongs_to :user
	has_many :shared_location_user_mappings, dependent: :destroy

	def self.register_new_location(latitude, longitude, user_id)
		@user = User.find(user_id)
		@new_location_obj = @user.shared_location_registers.new
		@new_location_obj.latitude = latitude 
		@new_location_obj.longitude = longitude
		@new_location_obj.save
		@location_id = @new_location_obj.id 
		return @location_id
	end

	def self.get_all_locations_shared_with_me(user_id)
		shared_location_objs = SharedLocationRegister
													.includes(:shared_location_user_mappings)
													.joins(:shared_location_user_mappings)
													.where("shared_location_user_mappings.shared_user_id = #{ user_id }" )
		
		respond_obj = []
		shared_location_objs.each do |loc|
			_inner_hash = loc.as_json
			_inner_hash["username"] = loc.user.username
			respond_obj << _inner_hash
		end
		return respond_obj
	end

	def self.get_all_my_shared_locations(user_id,is_only_public_sharings = false)
		where_str = "shared_location_registers.user_id = #{user_id}"
		if is_only_public_sharings
			where_str += " and shared_location_user_mappings.shared_user_id = 0"
		end

		shared_location_objs = SharedLocationRegister
													.includes(:shared_location_user_mappings)
													.references(:shared_location_user_mappings)
													.where(where_str)
		respond_obj = []
		shared_location_objs.each do |loc|
			_inner_hash = loc.as_json
			shared_user_id = loc.shared_location_user_mappings.pluck(:shared_user_id)
			if shared_user_id.present? && shared_user_id.length == 1 && shared_user_id.include?(0)
				_inner_hash["shared_mode"] = "Public"
			else
				_inner_hash["shared_mode"] = "Personal"
			end
			respond_obj << _inner_hash
		end
		return respond_obj
	end
end
