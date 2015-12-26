class RemoveEpochFromAwards < ActiveRecord::Migration
  def change
    remove_column :awards, :epoch
  end
end
