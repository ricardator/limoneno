class CreateProjectDatasets < ActiveRecord::Migration[6.0]
  def change
    create_table :project_datasets do |t|
      t.string :dataset_id
      t.json :dataset_id

      t.timestamps
    end

    add_index :project_datasets, [:dataset_id, :category_id]
  end
end
