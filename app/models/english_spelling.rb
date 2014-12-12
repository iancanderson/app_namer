class EnglishSpelling < ActiveRecord::Base
  def random_noun_synonym
    Array(noun_synonyms).sample
  end
end
