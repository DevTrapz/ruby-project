class CreateOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :orders do |t|
      t.belongs_to :user
      t.jsonb :podcast_ids
      t.timestamps
    end
  end
end
