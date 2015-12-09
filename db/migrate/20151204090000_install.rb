class Install < ActiveRecord::Migration

  def change
    create_table :artists do |t|
      t.column :name,           :string
      t.column :parent_id,      :integer
      t.timestamps
    end

    create_table :songs do |t|
      t.column :name,           :string
      t.column :parent_id,      :integer
      t.belongs_to :artist
      t.integer :initial_artist_id
      t.timestamps
    end

    create_table :stations do |t|
      t.string :name
      t.string :endpoint
      t.timestamps
    end

    create_table :broadcasts do |t|
      t.datetime :time
      t.string :name
      t.belongs_to :station, index: true
      t.belongs_to :song, index: true
      t.integer :initial_song_id
      t.belongs_to :crawl

      t.timestamps null: false
    end

    create_table :crawls do |t|
      t.belongs_to :station, index: true
      t.datetime :reference_time
      t.string :load_type
      t.integer :found_broadcasts, default: 0

      t.timestamps
    end
  end

end