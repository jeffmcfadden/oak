class CreateOakOutgoingWebmentions < ActiveRecord::Migration[5.2]
  def change
    create_table :oak_outgoing_webmentions do |t|
      t.string :source_url
      t.string :target_url
      t.datetime :sent_at

      t.timestamps
    end
  end
end
