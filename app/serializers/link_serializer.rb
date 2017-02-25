class LinkSerializer < ActiveModel::Serializer
  attributes :id, :url, :type, :user_id
end
