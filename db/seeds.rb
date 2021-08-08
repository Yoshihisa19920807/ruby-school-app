User.create!(email: 'admin@example.com', password: 'admin@example.com', password_confirmation: 'admin@example.com')
user = User.new(
  email: 'admin@example.com',
  password: 'admin@example.com',
  password_confirmation: 'admin@example.com'
)
user.skip_confirmation!
user.save

PublicActivity.enabled = false
30.times do
  @course = Course.new(
    title: Faker::Educator.course_name,
    short_description: Faker::TvShows::SiliconValley.motto,
    language: "English",
    level: "Beginner",
    # price: Faker::Number.between(from: 1, to: 20000),
    price: 0,
    description: Faker::TvShows::GameOfThrones.quote,
    user_id: User.first.id,
    published: true,
    approved: true,
  )
  @course.save(validation: false)
end
PublicActivity.enabled = true
