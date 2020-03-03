# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
for i in 1..10
    Track.create(
        title: Faker::Music.band,
        album: Faker::Music.album,
        description: Faker::Quote.famous_last_words,
    )

    puts "Created #{i} tracks"
end

for i in 1..10
    Genre.create(
        name: Faker::Music.genre,
    )

    puts "Created #{i} genres"
end