class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string      :token
      t.references  :user
      t.timestamps
    end
  end
end
