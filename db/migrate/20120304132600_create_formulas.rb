class CreateFormulas < ActiveRecord::Migration
  def self.up
    create_table :formulas do |t|
      t.string :text
      t.string :filename
      t.string :color
      t.integer :size

      t.timestamps
    end
    add_index :filename
  end

  def self.down
    drop_table :formulas
  end
end
