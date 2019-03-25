class CreateMaterial < ActiveRecord::Migration[4.2]
  def change
    create_table :materials do |t|
      t.string :name
      t.integer :subject_id
    end
  end
end
