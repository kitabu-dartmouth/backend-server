class LinkSerializer < ActiveModel::Serializer
  attributes :id, :url, :tag_list, :typep, :title
  belongs_to :user
end
