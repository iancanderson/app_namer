class AddRhymesToEnglishSpellings < ActiveRecord::Migration
  def change
    add_column :english_spellings, :rhymes, :string, array: true
  end
end
