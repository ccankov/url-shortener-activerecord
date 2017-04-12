class ShortenedUrl < ApplicationRecord
  validates :short_url, presence: true, uniqueness: true
  validates :long_url, presence: true
  validates :user_id, presence: true

  belongs_to :submitter,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: 'User'

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
end
