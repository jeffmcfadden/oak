class DropSiteConfigs < ActiveRecord::Migration[5.2]
  def change
    drop_table :oak_site_configs
  end
end
