class CreateCeremonies < ActiveRecord::Migration
  def up
    create_table :ceremonies do |t|
      t.string :frequency
      t.datetime :epoch_start
      t.datetime :epoch_end
      t.string :epoch_name
      t.timestamps null: false
    end

    change_table :awards do |t|
      t.belongs_to :ceremony, null: false
    end
  end

  def down
    drop_table :ceremonies
    remove_column :awards, :ceremony_id
  end
end
