require "domainr"

class AppNamesController < ApplicationController
  def new
    @verbs = load_verbs.keys.sort
  end

  def create
    if params[:commit] == "I'm feeling lucky!"
      params.each do |key, value|
        cookies["#{key}"] = value
      end

      @charge_amount = Random.rand(1...500)*100
      render "stripe_charge"
    else
      spelling = find_or_create_spelling(params[:direct_object].singularize.split(" ").last)
      pun = generate_pun(spelling)

      app_name = AppNameGenerator.generate(
        direct_object: params[:direct_object],
        spelling: spelling,
        verb: params[:verb]
      )

      icons = load_icons
      icon = icons[params[:verb]]["icons"].sample

      redirect_to app_name_url(
        app_name: app_name.name,
        direct_object: params[:direct_object],
        original_pun_phrase: pun && pun.original_phrase,
        tagline: pun && pun.new_phrase,
        verb: params[:verb],
        icon: icon
      )
    end
  end

  def show
    @app_name = params[:app_name]
    @direct_object = params[:direct_object]
    @original_pun_phrase = params[:original_pun_phrase]
    @tagline = params[:tagline]
    @verb = params[:verb]
    @icon = params[:icon]
  end

private
  def load_verbs
    YAML.load(File.open("config/lexicon/verbs.yml"))
  end

  def load_icons
    YAML.load(File.open("config/lexicon/icons.yml"))
  end

  def find_or_create_spelling(english_spelling)
    EnglishSpelling.find_by(spelling: english_spelling) || create_spelling(english_spelling)
  end

  def create_spelling(spelling)
    result = Dinosaurus.lookup(spelling)
    noun_attributes = result["noun"] || {}
    verb_attributes = result["verb"] || {}

    rhymes = RhymeService.new(spelling.split(" ").last).rhymes

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

  def generate_pun(spelling)
    if spelling.rhymes.any?
      GirlsJustWantToHavePuns.pun(
        params[:direct_object],
        minimum_word_count: 3,
        rhymes: spelling.rhymes
      )
    else
      nil
    end
  end
end
