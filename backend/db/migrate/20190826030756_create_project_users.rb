class CreateProjectUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :project_users do |t|
      t.string :user_id
      t.json :project_id

      t.timestamps
    end

    add_index :project_users, [:dataset_id, :dataset_id]
  end
end
