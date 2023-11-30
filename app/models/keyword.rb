class Keyword < ApplicationRecord
  SearchSites = { google: 'https://www.google.com/search' }.freeze

  validates_uniqueness_of :name, case_sensitive: false
end

