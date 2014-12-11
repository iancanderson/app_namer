class Word < ActiveRecord::Base
  validates :lexical_category, inclusion: { in: %w[noun verb] }
end
