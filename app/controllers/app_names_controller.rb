class AppNamesController < ApplicationController
  def new
    @verbs = load_verbs
  end

  def create
    # params[:verb]
    # params[:direct_object]
    verbs = load_verbs

    prefix_or_suffix = %w[prefixes suffixes].sample
    # 1.) Find a synonym for the verb
    verb_synonym = verbs[params[:verb]][prefix_or_suffix].sample.titleize
    # 2.) Find a synonym for the direct object
    direct_object_synonym = synonym_for(params[:direct_object]).singularize.titleize
    # 3.) Punnnnnify some stuff
    # 4.) Combine
    # 5.) Profit
    result = case prefix_or_suffix
             when "prefixes" then "#{verb_synonym}#{direct_object_synonym}"
             when "suffixes" then "#{direct_object_synonym}#{verb_synonym}"
    end

    pun = GirlsJustWantToHavePuns.puns(params[:direct_object]).sample
    motto = pun.new_phrase
    original_phrase = pun.original_phrase
    render text: [result, motto, original_phrase].join("; ")
  end

  def show
  end

private
  def load_verbs
    @verbs = YAML.load(File.open("config/lexicon/verbs.yml"))
  end

  def synonym_for(word)
    synonyms_for(word).sample
  end

  def synonyms_for(english_spelling)
    word = Word.find_by(
      english_spelling: english_spelling,
      lexical_category: "noun"
    )

    if word
      word.synonyms || []
    else
      noun = create_words(english_spelling)
      noun.synonyms || []
    end
  end

  def create_words(english_spelling)
    result = Dinosaurus.lookup(english_spelling)
    noun_attributes = result["noun"] || {}

    noun = Word.create!(
      english_spelling: english_spelling,
      lexical_category: "noun",
      synonyms: noun_attributes["syn"],
      related: noun_attributes["rel"],
      antonyms: noun_attributes["ant"]
    )

    verb_attributes = result["verb"] || {}

    Word.create!(
      english_spelling: english_spelling,
      lexical_category: "verb",
      synonyms: verb_attributes["syn"],
      related: verb_attributes["rel"],
      antonyms: verb_attributes["ant"]
    )

    noun
  end
end
