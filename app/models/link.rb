class Link < ApplicationRecord
    validates :url, :format => URI::regexp(%w(http https))
    belongs_to :user
    acts_as_taggable

    def get_user
        self.user.phoneno
    end
end
