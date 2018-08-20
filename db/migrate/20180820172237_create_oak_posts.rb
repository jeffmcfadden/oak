class CreateOakPosts < ActiveRecord::Migration[5.2]
  def change
    create_table :oak_posts do |t|
      t.string :title
      t.string :body
      t.datetime :published_at
      t.boolean :live
      t.integer :author_id

      t.timestamps
    end
  end
end
