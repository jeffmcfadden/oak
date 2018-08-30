class CreateOakIncomingWebmentions < ActiveRecord::Migration[5.2]
  def change
    create_table :oak_incoming_webmentions do |t|
      t.string :source_url
      t.string :target_url
      t.string :ip_address

      t.timestamps
    end
  end
end
