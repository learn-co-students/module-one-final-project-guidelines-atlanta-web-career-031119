User.destroy_all
Grade.destroy_all
Subject.destroy_all
Material.destroy_all


10.times do
User.create(
  name: Faker::Name.name,
  age: Faker::Number.between(12, 18),
  #grade_id: Grade.all.sample.id
)
end

10.times do
  Grade.create(
    grade_level: Faker::Number.between(7, 12)
  )
end

chemistry = Subject.create(name: "Chemistry", grade_id: Grade.all.sample.id)
american_history = Subject.create(name: "American History", grade_id: Grade.all.sample.id)
public_speaking = Subject.create(name: "Public Speaking", grade_id: Grade.all.sample.id)

compositon_book = Material.create(name: "composition book", subject: chemistry)
goggles = Material.create(name: "goggles", subject: chemistry)
american_history_textbook = Material.create(name: "The History of America Vol. 2", subject: american_history)
index_cards = Material.create(name: "index cards", subject: public_speaking)
stopwatch = Material.create(name: "stopwatch", subject: public_speaking)
