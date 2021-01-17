class HomeController < ApplicationController
  layout "custom"
  def index
      @username = current_user.username.capitalize
      user_id = current_user.id.to_i
      @my_shared_locations = SharedLocationRegister.get_all_my_shared_locations(user_id)
      
  end

  def users_list
    @all_users_list = User.fetch_all_users(current_user.id)
    puts @all_users_list.to_json
  end

  def location_shared_with_me
    user_id = current_user.id.to_i
    @location_shared_with_me_obj = SharedLocationRegister.get_all_locations_shared_with_me(user_id)
  end

  def publicly_shared_location_by_user
    username = params[:username]
    @username = username.capitalize
    puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
    if params[:username].present?
      user_id = User.where("username = '#{ username }'").take.id
      @my_shared_locations = SharedLocationRegister.get_all_my_shared_locations(user_id,true)
    end
  end
end
