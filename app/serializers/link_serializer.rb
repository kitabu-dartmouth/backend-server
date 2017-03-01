class LinkSerializer < ActiveModel::Serializer
  attributes :id, :url, :tag_list, :typep
  belongs_to :user
end
