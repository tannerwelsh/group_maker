class CreateProjectMembers < ActiveRecord::Migration
  def change
    create_table :project_members do |t|
      t.integer :user_id, null: false
      t.integer :project_id, null: false
      t.string :type, null: false, default: 'member'

      t.timestamps
    end
  end
end
