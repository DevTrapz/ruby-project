class CreateStudents < ActiveRecord::Migration[7.2]
  def change
    create_table :students do |t|
      t.belongs_to :user
      t.string :lauid
      t.string :first_name
      t.string :last_name
      t.string :username

      t.timestamps
    end
  end
end
