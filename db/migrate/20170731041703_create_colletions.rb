class CreateColletions < ActiveRecord::Migration[5.0]
  def change
    create_table :colletions do |t|
      t.integer :user_id, :index => true
      t.integer :post_id,  :index => true

      t.timestamps
    end
  end
end
