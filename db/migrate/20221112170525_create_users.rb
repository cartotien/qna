class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :nickname, null: false

      t.timestamps
    end

    change_table :questions do |t|
      t.references :user, null: false, foreign_key: true
    end

    change_table :answers do |t|
      t.references :user, null: false, foreign_key: true
    end
  end
end
