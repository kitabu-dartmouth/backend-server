class LinkSerializer < ActiveModel::Serializer
  attributes :id, :url, :tag_list, :typep, :title, :phoneno
  belongs_to :user
end
