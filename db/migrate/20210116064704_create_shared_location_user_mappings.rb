class CreateSharedLocationUserMappings < ActiveRecord::Migration[6.1]
  def change
    create_table :shared_location_user_mappings do |t|
      t.integer :shared_location_register_id
      t.integer :shared_user_id
      t.timestamps
    end
  end
end
