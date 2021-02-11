class SharedLocationUserMapping < ApplicationRecord
  belongs_to :shared_location_register
  PUBLIC_USER_ID = 0
  
  def self.share_location_with_user(location_id,user_id_arr=[])
    previous_shared_user_id_arr = self.user_mapping_data_location_id_wise(location_id).map{ |x| x.shared_user_id } rescue []
    if user_id_arr.length > 0
      #delete userwise
      if previous_shared_user_id_arr.length > 0
        need_to_delete_user_arr = previous_shared_user_id_arr - user_id_arr
        if need_to_delete_user_arr.length > 0
          #delete old records
          self.delete_old_location_with_user_mapping_data(location_id,need_to_delete_user_arr)
        end
      end

      need_to_newly_add_user_id_arr = user_id_arr - previous_shared_user_id_arr
      need_to_newly_add_user_id_arr.each do |user_id|
        self.insert_location_mapping_with_user(location_id, user_id)
      end
    else
      if previous_shared_user_id_arr.length > 0
        #delete all entry
        self.delete_old_location_with_user_mapping_data(location_id)
      end
      #publiclly shared coordinates are 
      self.insert_location_mapping_with_user(location_id, PUBLIC_USER_ID)
    end
  end

  # Method to fetch existing mapping data for the given location id
  def self.user_mapping_data_location_id_wise(location_id)
    mapping_data_obj = self.where("shared_location_register_id = #{ location_id }") rescue []
    return mapping_data_obj
  end

  #delte record from shared_location_user_mapping
  def self.delete_old_location_with_user_mapping_data(location_id,need_to_delete_user_arr=[])
    where_str = "shared_location_register_id = #{ location_id } "
    if need_to_delete_user_arr.length > 0
      where_str += " and shared_user_id IN (#{ need_to_delete_user_arr.join(',') })"
    end
    self.where(where_str).destroy_all
  end

  #insert mapping data user wise
  def self.insert_location_mapping_with_user(location_id,user_id)
    @shared_location_registers = SharedLocationRegister.find(location_id)
    @mapping_obj = @shared_location_registers.shared_location_user_mappings.new
    @mapping_obj.shared_user_id = user_id
    @mapping_obj.save
  end
end