
User.destroy_all
Review.destroy_all
Ticket.destroy_all
Event.destroy_all

tyler = User.create(name: "Tyler")
john = User.create(name: "John")
maggie = User.create(name: "Maggie")

hawks_gm1 = Event.create(name: "Atlanta Hawks vs LA Lakers",location: "Atlanta",venue: "State Farm Arena",genre: "basketball",date: "03/30/19",start_time: "7:00")
drake = Event.create(name: "Drake World Tour", location: "Atlanta",venue: "Infinite Energy Center",genre: "rap",date: "03/30/19",start_time: "8pm")
hawks_gm2 = Event.create(name: "Atlanta Hawks vs Brooklyn Nets",location: "Atlanta",venue: "State Farm Arena",genre: "basketball",date: "04/04/19",start_time: "7:00")
imagine_dragons = Event.create(name: "Imagine Dragons Tour",location: "Atlanta",venue: "Fox Theatre",genre: "rock",date: "04/06/19",start_time: "8pm")


rvw1 = Review.create(user_id: tyler.id, event_id: hawks_gm1.id, content: "I wish I would have gone to a hockey game instead.", recommend: 1)
rvw2 = Review.create(user_id: john.id, event_id: hawks_gm2.id, content: "Hawks suck. Don't waste your money.", recommend: 0)
rvw3 = Review.create(user_id: maggie.id, event_id: imagine_dragons.id, content: "Best show I have seen all year. Can't wait for them to come back!", recommend: 1)

tk1 = Ticket.create(user_id: tyler.id, event_id: hawks_gm1.id)
tk2 = Ticket.create(user_id: maggie.id, event_id: imagine_dragons.id)
tk3 = Ticket.create(user_id: john.id, event_id: hawks_gm2.id)
