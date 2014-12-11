class CreateWords < ActiveRecord::Migration
  def change
    create_table :english_spellings do |t|
      t.string :spelling, null: false

      t.string :noun_synonyms, array: true
      t.string :noun_related, array: true
      t.string :noun_antonyms, array: true
      t.string :verb_synonyms, array: true
      t.string :verb_related, array: true
      t.string :verb_antonyms, array: true

      t.timestamps
      t.index :spelling, unique: true
    end
  end
end
