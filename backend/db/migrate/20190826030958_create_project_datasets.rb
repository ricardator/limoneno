class CreateProjectDatasets < ActiveRecord::Migration[6.0]
  def change
    create_table :project_datasets do |t|
      t.integer :dataset_id
      t.integer :project_id

      t.timestamps
    end

    add_index :project_datasets, [:dataset_id, :project_id]
  end
end
