module LocationSharingsHelper
  def self.get_default_coordinates
    coordinates = YAML.load_file("#{ Rails.root }/config/config.yml")[Rails.env]["default_coordinates"] rescue []
    if coordinates.length == 0
      coordinates = [87.0656804, 23.2417663]
    end
    return coordinates
  end

  def get_all_user_list_except_current_user
    User.fetch_all_users(current_user.id)
  end
end
