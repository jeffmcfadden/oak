class CreateOakIndieauthAuthenticationRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :oak_indieauth_authentication_requests do |t|
      t.string :me
      t.string :client_id
      t.string :redirect_uri
      t.string :state
      t.string :code
      t.integer :user_id
      t.boolean :approved, default: false

      t.timestamps
    end
  end
end
