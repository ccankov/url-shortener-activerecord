class ShortenedUrl < ApplicationRecord
  validates :short_url, presence: true, uniqueness: true
  validates :long_url, presence: true
  validates :user_id, presence: true

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
end
