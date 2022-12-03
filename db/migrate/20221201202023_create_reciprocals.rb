class CreateReciprocals < ActiveRecord::Migration[7.0]
  def change
    create_table :reciprocals do |t|
      t.float :x
      t.float :y

      t.timestamps
    end
  end
end
