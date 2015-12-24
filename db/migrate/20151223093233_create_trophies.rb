class CreateTrophies < ActiveRecord::Migration
  def change
    create_table :trophies do |t|
      t.string :name
      t.integer :rank
      t.string :frequency
      t.integer :points
      t.string :applicable_on

      t.timestamps null: false
    end
  end
end
