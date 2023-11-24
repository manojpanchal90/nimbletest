class AddIndexAndUniquenessToKeyword < ActiveRecord::Migration[7.0]
  def change
    # Add an index to the column you want
    # Add uniqueness constraint to the column
    add_index :keywords, :name, unique: true
  end
end
