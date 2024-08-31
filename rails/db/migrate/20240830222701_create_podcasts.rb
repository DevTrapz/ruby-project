class CreatePodcasts < ActiveRecord::Migration[7.2]
  def change
    create_table :podcasts do |t|
      # t.belongs_to :order
      t.string :title
      t.string :url

      t.timestamps
    end
  end
end
