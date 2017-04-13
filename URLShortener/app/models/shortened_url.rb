class ShortenedUrl < ApplicationRecord
  validates :short_url, presence: true, uniqueness: true
  validates :long_url, presence: true
  validates :user_id, presence: true
  validate :no_spamming
  validate :nonpremium_max

  belongs_to :submitter,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: 'User'

  has_many :visits,
    primary_key: :id,
    foreign_key: :short_url_id,
    class_name: 'Visit'

  has_many :visitors,
    through: :visits,
    source: :visitor

  has_many :distinct_visitors,
    -> { distinct },
    through: :visits,
    source: :visitor

  has_many :taggings,
    primary_key: :id,
    foreign_key: :url_id,
    class_name: 'Tagging'

  has_many :topics,
    through: :taggings,
    source: :topic

  def self.random_code
    code = SecureRandom::urlsafe_base64
    while ShortenedUrl.exists?(short_url: code)
      code = SecureRandom::urlsafe_base64
    end
    code
  end

  def self.create!(long_url, user)
    url = ShortenedUrl.new(
      long_url: long_url,
      short_url: random_code,
      user_id: user.id
    )
    url.save
    url
  end

  # n minutes
  def self.prune(n)
    stale_urls = ShortenedUrl.joins(
      'LEFT JOIN
        (
          SELECT
            short_url_id, MAX(updated_at) as most_recent_visit
          FROM
            visits
          GROUP BY short_url_id
        ) as recent_visits ON shortened_urls.id = recent_visits.short_url_id'
    ).where(
      "(most_recent_visit < ? OR (most_recent_visit IS NULL AND shortened_urls.updated_at < ?))",
      n.minutes.ago,
      n.minutes.ago
    ).destroy_all
  end

  def num_clicks
    self.visits.length
  end

  def num_uniques
    self.distinct_visitors.length
  end

  def num_recent_uniques
    dv = self.distinct_visitors
    recent_dv = dv.where(updated_at: (10.minutes.ago..Time.now))
    recent_dv.length
  end

  private

  def no_spamming
    urls = ShortenedUrl.where(user_id: user_id)
    recent_urls = urls.where(created_at: (1.minutes.ago..Time.now))
    if recent_urls.length >= 5
      errors[:user_id] << "Dude...stop spamming"
    end
  end

  def nonpremium_max
    urls = ShortenedUrl.where(user_id: user_id)
    user = User.find_by(id: user_id)
    if urls.length >= 5 && !user.premium
      errors[:user_id] << "You need to pay $$$$"
    end
  end
end
