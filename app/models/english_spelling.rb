class EnglishSpelling < ActiveRecord::Base
  scope :alphabetical, -> { order(:spelling) }

  def random_noun_synonym
    Array(noun_synonyms).sample
  end
end
