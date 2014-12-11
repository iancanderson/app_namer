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
    spelling = EnglishSpelling.find_by(spelling: english_spelling) ||
      create_spelling(english_spelling)

    spelling.noun_synonyms || []
  end

  def create_spelling(spelling)
    result = Dinosaurus.lookup(spelling)
    noun_attributes = result["noun"] || {}
    verb_attributes = result["verb"] || {}

    EnglishSpelling.create!(
      spelling: spelling,
      noun_synonyms: noun_attributes["syn"],
      noun_related: noun_attributes["rel"],
      noun_antonyms: noun_attributes["ant"],
      verb_synonyms: verb_attributes["syn"],
      verb_related: verb_attributes["rel"],
      verb_antonyms: verb_attributes["ant"]
    )
  end
end
