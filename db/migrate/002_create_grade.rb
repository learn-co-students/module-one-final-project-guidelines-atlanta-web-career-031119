class CreateGrade < ActiveRecord::Migration[4.2]
  def change
    create_table :grades do |t|
      t.integer :grade_level
    end
  end
end
