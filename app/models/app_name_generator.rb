class AppNameGenerator
  def self.generate(options = {})
    new(options).generate
  end

  def initialize(direct_object:, spelling:, verb:)
    @direct_object = direct_object
    @spelling = spelling
    @verb = verb
  end

  def generate
    verbs = load_verbs

    prefix_or_suffix = %w[prefixes suffixes suffixes patterns].select do |mode|
      verbs[@verb][mode].present?
    end.sample

    # 1.) Find a synonym for the verb
    verb_synonym = verbs[@verb][prefix_or_suffix].sample.titleize
    # 2.) Find a synonym for the direct object

    direct_object_synonym = @spelling.random_noun_synonym.titleize
    # 3.) Punnnnnify some stuff
    # 4.) Combine
    # 5.) Profit
    result = case prefix_or_suffix
      when "prefixes" then "#{verb_synonym}#{direct_object_synonym}"
      when "suffixes" then "#{direct_object_synonym}#{verb_synonym}"
      when "patterns" then verb_synonym.downcase % { keyword: direct_object_synonym }
    end

    AppName.new(name: result.gsub(/\s/,''))
  end

  private

  def load_verbs
    @verbs ||= YAML.load(File.open("config/lexicon/verbs.yml"))
  end
end
