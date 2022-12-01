class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.references :user, null: false, foreign_key: true
      t.text :content, null: false
      t.belongs_to :commentable, polymorphic: true

      t.timestamps
    end
  end
end
