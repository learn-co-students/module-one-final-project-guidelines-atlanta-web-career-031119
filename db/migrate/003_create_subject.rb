class CreateSubject < ActiveRecord::Migration[4.2]
  def change
    create_table :subjects do |t|
      t.string :name
      t.integer :grade_id
    end
  end
end
