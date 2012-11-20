class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string  :name,        null: false
      t.string  :email,       null: false, default: ""
      t.integer :project_id

      t.timestamps
    end
  end
end
