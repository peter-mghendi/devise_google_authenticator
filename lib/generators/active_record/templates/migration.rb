class DeviseGoogleAuthenticatorAddTo<%= table_name.camelize %> < ActiveRecord::Migration
  def self.up
    change_table :<%= table_name %> do |t|
      t.string  :gauth_secret
      t.string  :gauth_enabled, :default => "f"
      t.string  :gauth_tmp
      t.datetime  :gauth_tmp_datetime
      t.datetime :remember_gauth_token_set_at
      t.datetime :remember_gauth_token_expires_at
    end
  end

  def self.down
    change_table :<%= table_name %> do |t|
      t.remove :gauth_secret, :gauth_enabled, :gauth_tmp, :gauth_tmp_datetime, :remember_gauth_token_set_at, :remember_gauth_token_expires_at
    end
  end
end
