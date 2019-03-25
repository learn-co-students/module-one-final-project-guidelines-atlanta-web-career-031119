User.destroy_all
Grade.destroy_all
Subject.destroy_all
Material.destroy_all


10.times do
User.create(
  name: Faker::Name.name,
  age: Faker::Number.between(12, 18)
)
end

10.times do
  Grade.create(
    grade_level: Faker::Number.between(7, 12)
  )
end
