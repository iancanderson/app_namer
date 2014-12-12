class ChargesController < ApplicationController
  def new
  end

  def create
    # Amount in cents
    @amount = 5000

    customer = Stripe::Customer.create(
      email: 'example@stripe.com',
      card: params[:stripeToken]
    )

    charge = Stripe::Charge.create(
      customer: customer.id,
      amount: @amount,
      description: 'Rails Stripe customer',
      currency: 'usd'
    )

    spelling = find_or_create_spelling(cookies["direct_object"].singularize)

    pun = GirlsJustWantToHavePuns.pun(
      cookies["direct_object"],
      minimum_word_count: 3,
      rhymes: spelling.rhymes
    )

    app_name = AppNameGenerator.generate(
      direct_object: cookies["direct_object"],
      spelling: spelling,
      verb: cookies["verb"]
    )

    redirect_to app_name_url(
      app_name: app_name.name,
      direct_object: cookies["direct_object"],
      original_pun_phrase: pun && pun.original_phrase,
      tagline: pun && pun.new_phrase,
      verb: cookies["verb"]
    )
  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to charges_path
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
