class CreateSubscriptions < ActiveRecord::Migration[5.1]
  def change
    create_table :subscriptions do |t|
      t.references :user
      t.references :question
      t.timestamps
    end

    add_index :subscriptions, [:user_id, :question_id]
  end
end
