class LocationSharingsController < ApplicationController
  def share_new_location
    render layout: false
  end

  def save_new_shared_location
		if params[:latitude].present? && params[:longitude].present?
			latitude = params[:latitude]
			longitude = params[:longitude]
			curren_user_id = current_user.id
			new_location_id = SharedLocationRegister.register_new_location(latitude,
																											longitude, curren_user_id) 
			if params[:user_id_arr].present?
				user_id_arr = params[:user_id_arr].split(',')
				if user_id_arr.length == 1 && user_id_arr[0].downcase == "public"
					SharedLocationUserMapping.share_location_with_user(new_location_id)
				else
					SharedLocationUserMapping.share_location_with_user(new_location_id,user_id_arr)
				end	
				render plain: "Location shared successfully." 
			else
				render plain: "Can't share location without user selection."
			end
		else
			render plain: "Can't share location without latitude and longitude."
		end	
	end
	
	def show_location
		@latitude=params[:latitude]
		@longitude=params[:longitude]
		render layout: false
	end

	def delete_location
		if params[:location_id].present?
			location_id = params[:location_id]
			SharedLocationRegister.find(location_id).destroy
			render plain: "Delete completed;"
		else
			render plain: "Delete Operation faild"
		end
	end

	def share_old_location
		if params[:location_id].present? && params[:user_id_arr].present?
			user_id_arr = params[:user_id_arr].split(',')
			location_id = params[:location_id]
			if user_id_arr.length == 1 && user_id_arr[0].downcase == "public"
				SharedLocationUserMapping.share_location_with_user(location_id)
			else
				SharedLocationUserMapping.share_location_with_user(location_id,user_id_arr)
			end	
			render plain: "Share location successfully."
		else
			render plain: "Share Faild."
		end
	end
end
