class AdminController < ApplicationController
  def spellings
    @spellings = EnglishSpelling.alphabetical
  end
end
