class Keyword < ApplicationRecord
  SearchSites = { google: 'https://www.google.com/' }

  validates_uniqueness_of :name

end
