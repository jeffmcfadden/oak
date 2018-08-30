class ChangeSourceUrlToPostInOutgoingWebmention < ActiveRecord::Migration[5.2]
  def change
    remove_column :oak_outgoing_webmentions, :source_url
    add_column :oak_outgoing_webmentions, :post_id, :integer
  end
end
