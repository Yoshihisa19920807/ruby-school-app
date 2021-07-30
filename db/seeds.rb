# User.create!(email: 'admin@example.com', password: 'admin@example.com', password_confirmation: 'admin@example.com')
user = User.new(
  email: 'admin@example.com',
  password: 'admin@example.com',
  password_confirmation: 'admin@example.com'
)
user.skip_confirmation!
user.save

PublicActivity.enabled = false
30.times do
  Course.create!([{
    title: Faker::Educator.course_name,
    short_description: Faker::TvShows::SiliconValley.motto,
    language: "English",
    level: "Beginner",
    price: Faker::Number.between(from: 1, to: 20000),
    description: Faker::TvShows::GameOfThrones.quote,
    user_id: User.first.id
  }])
end
PublicActivity.enabled = true
