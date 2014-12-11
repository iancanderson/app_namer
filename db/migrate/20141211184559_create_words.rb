class CreateWords < ActiveRecord::Migration
  def change
    create_table :words do |t|
      t.string :english_spelling, null: false
      t.string :lexical_category, null: false

      t.string :synonyms, array: true
      t.string :related, array: true
      t.string :antonyms, array: true

      t.timestamps
      t.index [:english_spelling, :lexical_category], unique: true
    end
  end
end
