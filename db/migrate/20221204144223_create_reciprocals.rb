class CreateReciprocals < ActiveRecord::Migration[7.0]
  def change
    create_table :reciprocals do |t|
      t.float :x
      t.float :y
      t.float :val_n
      t.float :n_g

      t.timestamps
    end
  end
end
