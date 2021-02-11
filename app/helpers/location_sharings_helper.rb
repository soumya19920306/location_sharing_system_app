module LocationSharingsHelper
  def self.get_default_coordinates
    coordinates = YAML.load_file("#{Rails.root}/config/config.yml")[Rails.env]["default_coordinates"] rescue []
    if coordinates.length == 0
      coordinates = [87.0656804,23.2417663]
    end
    return coordinates
  end

  def get_all_user_list_except_current_user
    User.fetch_all_users(current_user.id)
  end

  def button_html_creator_for_locations(value,method,latitude,longitude)
    html_str = "<input class='btn-cust' type='button' value='#{value}' onclick='#{method}(#{longitude.to_s},#{latitude.to_s})' />"
  end

  def button_html_creator_for_users(user_name)
    html_str = "<input class='btn-cust' type='button' value='Show' onclick='show_user_shared_location(\"#{user_name.to_s}\")' />"
  end
end
