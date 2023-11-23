class CreateKeywords < ActiveRecord::Migration[7.0]
  def change
    create_table :keywords do |t|
      t.string :name
      t.integer :total_adwords
      t.integer :total_links
      t.integer :search_count
      t.text :html_content

      t.timestamps
    end
  end
end
