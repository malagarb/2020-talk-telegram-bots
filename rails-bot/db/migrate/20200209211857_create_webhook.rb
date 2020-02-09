class CreateWebhook < ActiveRecord::Migration[6.0]
  def change
    create_table :webhooks do |t|
      t.integer :chat_id
      t.string  :telegram_date
      t.string  :from_user
      t.integer :from_user_id
      t.string  :from_ip
      t.string  :language_code
      t.json    :payload_received
      t.json    :payload_received_reply
      t.json    :payload_sent
      t.json    :payload_sent_reply
      t.json    :payload_rswebapp
      t.json    :payload_rswebapp_reply
      t.json    :payload_result
      t.boolean :process_status
      t.timestamps
    end
  end
end
