class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :type_of
      t.integer :state
      t.timestamps
    end
  end
end
