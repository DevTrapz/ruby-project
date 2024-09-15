class CreateCourses < ActiveRecord::Migration[7.2]
  def change
    create_table :courses do |t|
      t.belongs_to :user
      t.string :name

      t.timestamps
    end
  end
end
