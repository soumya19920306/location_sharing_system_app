class SharedLocationRegister < ApplicationRecord
	has_many :shared_location_user_mappings, dependent: :destroy

	def self.register_new_location(latitude, longitude, user_id)
		new_location_obj = self.new
		new_location_obj["latitude"] = latitude
		new_location_obj["longitude"] = longitude
		new_location_obj["user_id"] = user_id
		new_location_obj.save
		location_id = new_location_obj.id
		return location_id
	end

	def self.get_all_locations_shared_with_me(user_id)

		shared_location_objs = SharedLocationRegister.includes(:shared_location_user_mappings).joins(:shared_location_user_mappings)
																													.where("shared_location_user_mappings.shared_user_id = #{ user_id }" )
		all_users_obj = User.all
		user_id_name_hmap = all_users_obj.inject({}) { |x,y| x[y['id'].to_i] = y['username']; x }
		respond_obj = []

		shared_location_objs.each do |loc|
			_inner_hash = loc.as_json
			_inner_hash["username"] = user_id_name_hmap[loc.user_id]
			_inner_hash["show_on_map"] = "<input class='btn-cust' type='button' value='Show' onclick='show_location("+loc.longitude.to_s+","+loc.latitude.to_s+")' />"
			respond_obj << _inner_hash
		end
		return respond_obj
	end

	def self.get_all_my_shared_locations(user_id,is_only_public_sharings = false)
		if is_only_public_sharings
			shared_location_objs = SharedLocationRegister
		 												.includes(:shared_location_user_mappings)
														.references(:shared_location_user_mappings)
														.where("shared_location_registers.user_id = #{user_id} and shared_location_user_mappings.shared_user_id = 0" )
		else
			shared_location_objs = SharedLocationRegister.where("user_id in (#{user_id})")
		end
		respond_obj = []
		shared_location_objs.each do |loc|
			_inner_hash = loc.as_json
			_inner_hash["show_on_map"] = "<input class='btn-cust' type='button' value='Show' onclick='show_location("+loc.longitude.to_s+","+loc.latitude.to_s+")' />"
			_inner_hash["share_location"] = "<input class='btn-cust' type='button' value='Share' onclick='openLocationShareModal("+loc.id.to_s+")' />"
			_inner_hash["delete_location"] = "<input class='btn-cust' type='button' value='Delete' onclick='deleteLocation("+loc.id.to_s+")' />"
			shared_user_id = SharedLocationUserMapping.where("shared_location_register_id = #{loc.id}").pluck(:shared_user_id)
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
