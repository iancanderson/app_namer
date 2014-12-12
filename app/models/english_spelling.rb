class EnglishSpelling < ActiveRecord::Base
  scope :alphabetical, -> { order(:spelling) }

  def random_synonym
    Array(noun_synonyms).sample || Array(verb_synonyms).sample
  end
end
