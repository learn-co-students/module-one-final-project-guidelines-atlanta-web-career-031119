maddie = User.create(name: "Maddie", location: "Atlanta, GA USA")
sam = User.create(name: "Sam", location: "Atlanta, GA USA")
padfoot = User.create(name: "Padfoot", location: "London, England")
sarah = User.create(name: "Sarah", location: "Sydney, Australia")
kevin = User.create(name: "Kevin", location: "Brookyln, NY USA")
taylor = User.create(name: "Taylor", location: "Wellington, NZ")

vamp_sighting = Post.create(user_id: maddie.id, monster_id: vampire.id, title: "Bloodsucker on the beltline!", content: "Last night my wife and I were walking on the beltline just after dusk. We saw a strange humanoid figure emerge from the shadows. As our instincts told us to speed up, it matched our pace. We only got away by running into an italian restaurant. tl;dr BOLO for vampire in Virginia highlands!")

squatch_hunt = Post.create(user_id: padfoot.id, monster_id: sasquatch.id, title: "Squatch Hunt", content: "My buddy and I went out squatch hunting last weekend. You would not believe what we saw!!! After finishing up dinner we got a hit on one of our trip wire alarms. We tied a bunch of cans up around the perimeter of our site to alert us if anything came close. Anyway, we're sittin' by the fire and we hear the cans going off. Leaves crunchin', knocks on the wood. Then right in front of our gottdamn eyes we see a huge shadow rush past and a smell like rotten meat fills the  air. Then everything went quiet. Didn't hear nuthin else all night.")

leviathan_lake_errie = Post.create(user_id: kevin.id, monster_id: leviathan.id, title: "Leviathan in Lake Errie!", content: "I was visiting an old college friend a couple of months back . We went out on the lake with some friends to party on their boat. So we're out there anchored and just chillin' out when suddenly there's this huge thud. I'm talking like people getting knocked over, drinks everywhere. That kind of thud. We rush onto the deck to see what's going on and we catch a glimpse of a HUGE shadow swimming away. Bigger than the boat. Eerie is ginormous. Just about anything could be in there.")


sam_comment = Comment.create(user_id: sam.id, post_id: vamp_sighting.id, content: "Scary! Smart thinking running into the italian restuarant!")

taylor_comment = Comment.create(user_id: taylor.id, post_id: squatch_hunt.id, content: "What woods were you in? My wife and I go camping all the time and I'd like to AVOID that area. Lol!")

maddie_comment = Comment.create(user_id: maddie.id, post_id: squatch_hunt.id, content: "Did you set out any trail cameras?! Pics or it didn't happen!")

vampire = Monster.create(name: "Vampire", description: "Bloodsucking humanoids. Can only be killed by a stake to the heart. Avoids sunlight", location: "Global")

sasquatch = Monster.create(name:"Sasquatch", description: "Large and hairy ape-like creature" location: "Canada and the USA")

leviathan = Monster.create(name: "Leviathan", description: "any large, unidentifiable, aquatic cryptid", location: "Unknown")

chupacabra = Monster.create(name: "Chupacabra", description: "dog-sized mammalian cryptids with large eyes and bigger appetitites. Known to suck the blood of goats" location: "Central America")