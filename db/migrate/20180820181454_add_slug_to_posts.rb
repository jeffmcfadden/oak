class AddSlugToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :oak_posts, :slug, :string
    add_index :oak_posts, :slug, unique: true
  end
end
