class Link < ApplicationRecord
    validates :url, :format => URI::regexp(%w(http https))
    belongs_to :user
    acts_as_taggable
end
