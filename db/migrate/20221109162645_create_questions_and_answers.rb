class CreateQuestionsAndAnswers < ActiveRecord::Migration[6.0]
  def change
    create_table :questions do |t|
      t.string :title
      t.text :body

      t.timestamps
    end

    create_table :answers do |t|
      t.text :body
      t.references :question, null: false, foreign_key: true

      t.timestamps
    end
  end
end
