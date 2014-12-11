class EnglishSpelling < ActiveRecord::Base
  def random_noun_synonym
    noun_synonyms.sample
  end
end
