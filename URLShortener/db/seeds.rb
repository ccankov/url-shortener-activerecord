# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

chris = User.create(email: 'chris@fake.com')
nathan = User.create(email: 'nathan@fake.com')

google = ShortenedUrl.create!('www.google.com', chris)
duckduckgo = ShortenedUrl.create!('www.duckduckgo.com', nathan)
cnn = ShortenedUrl.create!('www.cnn.com', nathan)
espn = ShortenedUrl.create!('www.espn.com', chris)

search = TagTopic.create(topic: 'search')
news = TagTopic.create(topic: 'news')
sports = TagTopic.create(topic: 'sports')
music = TagTopic.create(topic: 'music')

google_search = Tagging.create(url_id: google.id, topic_id: search.id)
duckduckgo_search = Tagging.create(url_id: duckduckgo.id, topic_id: search.id)
cnn_news = Tagging.create(url_id: cnn.id, topic_id: news.id)
espn_sports = Tagging.create(url_id: espn.id, topic_id: sports.id)

u1 = User.create!(email: "jefferson@cats.com", premium: true)
u2 = User.create!(email: "muenster@cats.com")

su1 = ShortenedUrl.create!("www.boxes.com", u1)
su2 = ShortenedUrl.create!("www.meowmix.com", u2)
su3 = ShortenedUrl.create!("www.smallrodents.com", u2)

v1 = Visit.create!(user_id: u1.id, short_url_id: su1.id)
v2 = Visit.create!(user_id: u1.id, short_url_id: su2.id)
