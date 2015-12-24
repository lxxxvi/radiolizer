class CreateAwards < ActiveRecord::Migration
  def change
    create_table :awards do |t|
      t.references :awardable, polymorphic: true, index: true
      t.belongs_to :station
      t.belongs_to :trophy
      t.string :epoch
      t.integer :play_count

      t.timestamps null: false
    end
  end
end
