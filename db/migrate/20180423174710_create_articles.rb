class CreateArticles < ActiveRecord::Migration[5.2]
  def change
    create_table :articles do |t|
      t.string :imgURL
      t.string :header
      t.text :body
      t.boolean :live
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
