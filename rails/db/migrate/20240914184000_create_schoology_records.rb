class CreateSchoologyRecords < ActiveRecord::Migration[7.2]
  def change
    create_table :schoology_records do |t|
      t.belongs_to :student
      t.belongs_to :course
      t.jsonb :grades

      t.timestamps
    end
  end
end
