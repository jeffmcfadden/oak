class CreateOakIndieauthAuthorizationRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :oak_indieauth_authorization_requests do |t|
      t.string :me
      t.string :client_id
      t.string :redirect_uri
      t.string :state
      t.string :scope
      t.string :code
      t.integer :user_id
      t.boolean :approved, default: false
      t.string :access_token

      t.timestamps
    end
  end
end
