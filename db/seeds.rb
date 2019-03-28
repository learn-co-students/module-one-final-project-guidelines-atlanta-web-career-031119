User.destroy_all
Grade.destroy_all
Subject.destroy_all
Material.destroy_all
require 'pry'

freshman = Grade.create(grade_level: 9)
sophomore = Grade.create(grade_level: 10)
junior = Grade.create(grade_level: 11)
senior = Grade.create(grade_level: 12)

10.times do
User.create(
  name: Faker::Name.name,
  age: Faker::Number.between(12, 18),
  grade_id: Grade.all.sample.id
)
end

chemistry = Subject.create(name: "Chemistry", grade_id: freshman.id)
earth_science = Subject.create(name: "Earth Science", grade_id: freshman.id)
ecology = Subject.create(name: "Ecology", grade_id: sophomore.id)
geology = Subject.create(name: "Geology", grade_id: sophomore.id)
anatomy = Subject.create(name: "Anatomy", grade_id: junior.id)
biology = Subject.create(name: "Biology", grade_id: junior.id)
physics = Subject.create(name: "Physics", grade_id: senior.id)
environmental_science = Subject.create(name: "Environmental Science", grade_id: senior.id)
world_religion = Subject.create(name: "World Religion", grade_id: freshman.id)
us_gov = Subject.create(name: "U.S. Government", grade_id: freshman.id)
geography = Subject.create(name: "Geography", grade_id: freshman.id)
european_history = Subject.create(name: "European History", grade_id: sophomore.id)
african_american_history = Subject.create(name: "African American History", grade_id: sophomore.id)
middle_eastern_history = Subject.create(name: "Middle Eastern History", grade_id: junior.id)
latin_american_studies = Subject.create(name: "Latin American Studies", grade_id: junior.id)
french_revolution = Subject.create(name: "French Revolution", grade_id: senior.id)
american_history = Subject.create(name: "American History", grade_id: senior.id)
public_speaking = Subject.create(name: "Public Speaking", grade_id: freshman.id)
british_literature = Subject.create(name: "British Literature", grade_id: sophomore.id)
american_literature = Subject.create(name: "American Literature", grade_id: junior.id)
greek_mythology = Subject.create(name: "Greek Mythology", grade_id: senior.id)
algebra = Subject.create(name: "Algebra", grade_id: freshman.id)
trigonometry = Subject.create(name: "Trigonometry", grade_id: freshman.id)
geometry = Subject.create(name: "Geometry", grade_id: sophomore.id)
statistics = Subject.create(name: "Statistics", grade_id: junior.id)
calculus = Subject.create(name: "Calculus", grade_id: senior.id)
political_science = Subject.create(name: "Political Science", grade_id: senior.id)
spanish = Subject.create(name: "Spanish", grade_id: junior.id)
french = Subject.create(name: "French", grade_id: junior.id)
art_history = Subject.create(name: "Art History", grade_id: senior.id)
psychology = Subject.create(name: "Psychology", grade_id: senior.id)
astronomy = Subject.create(name: "Astronomy", grade_id: sophomore.id)
economics = Subject.create(name: "Economics", grade_id: sophomore.id)

compositon_book = Material.create(name: "composition book", subject_id: Subject.all.sample.id)
goggles = Material.create(name: "goggles", subject_id: Subject.all.sample.id)
american_history_textbook = Material.create(name: "The History of America Vol. 2", subject_id: Subject.all.sample.id)
index_cards = Material.create(name: "index cards", subject_id: Subject.all.sample.id)
stopwatch = Material.create(name: "stopwatch", subject_id: Subject.all.sample.id)
