class AppNamesController < ApplicationController
  def new
    @verbs = load_verbs.sort
  end

  def create
    # params[:verb]
    # params[:direct_object]
    verbs = load_verbs

    prefix_or_suffix = %w[prefixes suffixes].select do |mode|
      verbs[params[:verb]][mode].present?
    end.sample

    # 1.) Find a synonym for the verb
    verb_synonym = verbs[params[:verb]][prefix_or_suffix].sample.titleize
    # 2.) Find a synonym for the direct object

    spelling = find_or_create_spelling(params[:direct_object].singularize)

    direct_object_synonym = spelling.random_noun_synonym.titleize
    # 3.) Punnnnnify some stuff
    # 4.) Combine
    # 5.) Profit
    result = case prefix_or_suffix
             when "prefixes" then "#{verb_synonym}#{direct_object_synonym}"
             when "suffixes" then "#{direct_object_synonym}#{verb_synonym}"
    end

    pun = GirlsJustWantToHavePuns.pun(
      params[:direct_object],
      rhymes: spelling.rhymes
    )

    @verb = params[:verb]
    @keyword = params[:direct_object]
    @app_name = result.gsub(/\s/,'')
    @motto = pun && pun.new_phrase
    @original_phrase = pun && pun.original_phrase
  end

private
  def load_verbs
    @verbs = YAML.load(File.open("config/lexicon/verbs.yml"))
  end

  def find_or_create_spelling(english_spelling)
    EnglishSpelling.find_by(spelling: english_spelling) || create_spelling(english_spelling)
  end

  def create_spelling(spelling)
    result = Dinosaurus.lookup(spelling)
    noun_attributes = result["noun"] || {}
    verb_attributes = result["verb"] || {}

    rhymes = RhymeService.new(spelling).rhymes

    EnglishSpelling.create!(
      spelling: spelling,
      noun_synonyms: noun_attributes["syn"],
      noun_related: noun_attributes["rel"],
      noun_antonyms: noun_attributes["ant"],
      verb_synonyms: verb_attributes["syn"],
      verb_related: verb_attributes["rel"],
      verb_antonyms: verb_attributes["ant"],
      rhymes: rhymes
    )
  end
end
