class AddDepthToFormulas < ActiveRecord::Migration
  def self.up
    add_column :formulas, :depth, :integer
  end

  def self.down
    remove_column :formulas, :depth
  end
end
