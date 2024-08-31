class CreatePermissions < ActiveRecord::Migration[7.2]
  def change
    create_table :permissions do |t|
      t.belongs_to :user
      t.string :permission_type

      t.timestamps
    end
  end
end
