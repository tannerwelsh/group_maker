class CreateProjectChoices < ActiveRecord::Migration
  def change
    create_table :project_choices do |t|
      t.integer :user_id, null: false
      t.integer :project_id, null: false
      t.integer :priority, null: false

      t.timestamps
    end
  end
end
