class CreateOakSiteConfigs < ActiveRecord::Migration[5.2]
  def change
    create_table :oak_site_configs do |t|
      t.string :key
      t.string :value

      t.timestamps
    end
  end
end
