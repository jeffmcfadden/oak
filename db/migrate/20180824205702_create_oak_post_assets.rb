class CreateOakPostAssets < ActiveRecord::Migration[5.2]
  def change
    create_table :oak_post_assets do |t|

      t.timestamps
    end
  end
end
