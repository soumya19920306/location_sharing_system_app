module HomeHelper
  def button_html_creator_for_location_show(value, method, latitude, longitude)
    html_str = "<input class='btn-cust' type='button' value='#{ value }' onclick='#{ method }(#{ longitude.to_s },#{ latitude.to_s })' />"
  end
  
  def button_html_creator_for_location_share_delete(value, method, loc_id)
    html_str = "<input class='btn-cust' type='button' value='#{ value }' onclick='#{ method }(#{ loc_id.to_s })' />"
  end
  
  def button_html_creator_for_users(user_name)
    html_str = "<input class='btn-cust' type='button' value='Show' onclick='show_user_shared_location(\"#{ user_name.to_s }\")' />"
  end
end
