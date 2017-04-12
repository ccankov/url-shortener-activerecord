class TagTopic < ApplicationRecord
  validates :topic, presence: true, uniqueness: true

  has_many :taggings,
    primary_key: :id,
    foreign_key: :topic_id,
    class_name: 'Tagging'

  has_many :urls,
    through: :taggings,
    source: :url

  # return 5 most poular links
  # also return number of clicks
  def popular_links
    result = {}
    urls[0...5].each do |url|
      result[url] = url.num_clicks
    end
    result
  end
end
