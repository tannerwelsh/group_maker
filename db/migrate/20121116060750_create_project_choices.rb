class CreateProjectChoices < ActiveRecord::Migration
  def change
    create_table :project_choices do |t|
      t.integer :user_id
      t.integer :project_id
      t.integer :priority

      t.timestamps
    end
  end
end
