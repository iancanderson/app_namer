require 'json'
require 'open-uri'

class RhymeService

  def initialize keyword
    @keyword = keyword
  end

  def rhymes
    rhyme_hashes = JSON.parse(fetch_rhymes)
    return [] if rhyme_hashes.empty?

    max_score = rhyme_hashes.max_by { |r| r['score'] }['score']

    rhyme_hashes.select do |r|
      r['score'] == max_score
    end.map do |rhyme|
      rhyme['word']
    end
  end

  private

  def fetch_rhymes
    word = URI::encode(@keyword)
    open("http://rhymebrain.com/talk?function=getRhymes&word=#{word}&maxResults=0&lang=en").read
  end

end
