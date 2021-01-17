class CreateSharedLocationRegisters < ActiveRecord::Migration[6.1]
  def change
    create_table :shared_location_registers do |t|
      t.integer :user_id
      t.decimal :latitude, precision: 11, scale: 8
      t.decimal :longitude, precision: 11, scale: 8
      t.timestamps
    end
  end
end
