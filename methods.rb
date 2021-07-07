
### Abdul's Methods

###CALLED IN MAIN USER MENU

def newuser()

     puts "PLEASE ENTER YOUR USER NAME"

     username = gets.chomp

     if User.all.size == 0

        createuser(username)
      end


      checkuser(username) ##PASS PARAMETERS USER NAME FOR CHECKING USER

end

### CALLED FOR CHECKING IF USER ALREADY EXISTS (PARAMETERS FROM NEWUSER )
def checkuser(name)
   #movie = Movie.find_by(title: name)
    #if user.where(name: name)
   #if movie.nil?

      user = User.find_by(name: name)
      #binding.pry
      if user.nil?
     #if user.name.downcase == name.downcase
     puts "NEW USER CREATED"
     createuser(name)

     else
      puts "USER FOUND "
    end
     moviesmenu(name)
end
####################################################################

def createuser(name)

 user = User.new(name: name)
 user.save
 puts "Your USERNAME IS  #{User.last.name}"
 moviesmenu(name)
end


############################################################################

def moviescheck(name,username)

  Movie.all.each do |title|

  if title.title == name
  watchlistupdate(name,username)
  puts "run watchlist update "

  end
  end.first
   addmovie(name)
   watchlistupdate(name,username)
   puts "movies and watchlist updated"
   end
# moviesmenu(username)

   name = "abdul"
   Watchlist.all.each do |movies|

 #if movies.user.name == name
  puts movies.movie.title
 #puts "MOVIE ID is #{movies.movie.title} TITLE IS #{movies.movie.id}"
 #binding.pry
 #end
   end



######################ADDD MOVIE TO DATABASE ##################################



def addmovie(name)

  x = name


  url = "http://www.omdbapi.com/?t=#{x}&apikey=8699c2be"

  x = RestClient.get(url)
  response = JSON.parse(x)
  #puts response["Runtime"]
  #puts response["Ratings"].first["Value"]


   title = response["Title"]
   release_date = response["Released"]
   plot = response["Plot"]
   ratings = response["Ratings"].first["Value"]
   username = "prince"
   runtime = response["Runtime"]
   superman = Movie.new(title: title, release_date: release_date, plot: plot, rating: ratings, runtime: runtime)
   superman.save
    array = [title,release_date,plot,ratings,runtime]

   end


   ########################ADDING TO WATCH LIST ###########################

  def watchlistupdate(name,username)



    moviename = Movie.find_by(title: name)
    user = User.find_by(name: username)
    movieid = moviename.id
    userid = user.id
   #  Movie.all.each do |title|

    #if title.title == name
     #movieid = title.id

     puts "THE MOVIE ID IS #{movieid}"
     puts "THE USER ID IS #{userid}"
     puts "THE MOVIES NAME IS #{moviename.title}"
     puts "THE USER NAME IS #{user.name}"
    watch = Watchlist.new(user_id: userid, movie_id: movieid, rating: 0.0, review: "", watched: false  )
    watch.save
end
################################################################################################
##############REMOVE MOVIE FROM WATCHLIST################################################
def removemovie(name)  ## user name
   puts "Please enter the movie which you want to remove "

    response = gets.chomp
    userid = ""
    movieid = ""

    id = Movie.where(title: response)
    movieid = id.ids[0]
      # binding.pry
      puts movieid
    if movieid.nil?

      puts " No movie found in your watchlist "
         removemovie(name)
     else
        id = User.where(name: name)
        userid = id.ids[0]
        puts userid
        #binding.pry

       hell = Watchlist.where("user_id = #{userid} and movie_id = #{movieid}")
       puts hell
       #binding.pry

             if hell.size == 0

              puts "NO MOVIE FOUND IN WATCH LIST PLEASE CHECK NAME "

              removemovie(name)

            else
            Watchlist.destroy(Watchlist.where("user_id = #{userid} and movie_id = #{movieid}"))

             puts "MOVIE DELETED FROM WATCH LIST"
             moviesmenu(name)
           end
      end
end
#################################UPDATE REVIEW################################################################

def updatereview(name)  ## user name
   puts "Please enter the movie which you want to review "

    response = gets.chomp
    userid = ""
    movieid = ""

    id = Movie.where(title: response)
    movieid = id.ids[0]
      # binding.pry
      puts movieid
    if movieid.nil?

      puts " No movie found in your watchlist "
         removemovie(name)
     else
        id = User.where(name: name)
        userid = id.ids[0]
        #puts userid
        #binding.pry

       hell = Watchlist.where("user_id = #{userid} and movie_id = #{movieid}")
       #puts hell
       #binding.pry

             if hell.size == 0

              puts "NO MOVIE FOUND IN WATCH LIST PLEASE CHECK NAME "

              removemovie(name)

            else

            puts " Please Type Your Review Below When ready press Enter key "

              review = gets.chomp

              hell.update(review: "#{review}")
              puts "Please Type Your Rating from 0 - 10"

                rating = gets.chomp

              hell.update(rating: "#{rating}")
                #binding.pry
               #hell.save
            # Watchlist.destroy(Watchlist.where("user_id = #{userid} and movie_id = #{movieid}"))
            #
             puts "Thank you for your Review and Rating "


             moviesmenu(name)
           end
      end
end
###########################WATCH STATUS UPDATE ##########################

def watchmovie(name)  ## user name
   puts "Please enter the movie which you want to watch "

    response = gets.chomp
    userid = ""
    movieid = ""

    id = Movie.where(title: response)
    movieid = id.ids[0]
      # binding.pry
      puts movieid
    if movieid.nil?

      puts " No movie found in your watchlist "
         moviewatchmenu(name)
     else
        id = User.where(name: name)
        userid = id.ids[0]
        #puts userid
        #binding.pry

       hell = Watchlist.where("user_id = #{userid} and movie_id = #{movieid}")
       #puts hell
       #binding.pry

             if hell.size == 0

              puts "NO MOVIE FOUND IN WATCH LIST PLEASE CHECK NAME "

              #removemovie(name)

            else

              hell.update(watched: true)


            puts "thank you for your confirmation "



            watchmovies(response)
            #  moviesmenu(name)


           end
      end
end

###############################################most popular movie ###############

def mostpopularmovie()
  x =  Watchlist.all.group(:movie_id).count

  y = x.sort_by{|k,v| -v}.first

    y[0]

  z = Movie.where(id: y[0])

   puts "THE MOST POPULAR MOVIE IS #{z[0].title}"
  #binding.pry

end

#########################THIS IS MOVIE HIGHEST RATING###################################################
def highestrating()
  x = Watchlist.maximum(:rating)
  y = Watchlist.where("rating = #{x}")
  #puts y[0]
  i = 0
  while i < y.length
    puts "THE MOVIE WITH HIGHEST RATING IS #{y[i].movie.title}"
    i +=1
  end
end

############################################################################################

def Usermaxmovies()

  x = Watchlist.all.group(:user_id).count

  y = x.sort_by{|key,values| -values}.first


    z = User.where("id = #{y[0]}").pluck(:name)


    puts "THE USER WITH HIGHEST NUMBER OF MOVIES IS #{z.join}."
    # binding.pry




end

#####################MOVIES WATCHED##################################################################
def watchmovies(name)

  x = User.where(name: name).pluck(:id)

  puts x

  jaaz = Watchlist.where("user_id = #{x[0]} and watched = ?",true)

  #binding.pry

  i = 0
  while i < jaaz.length
  puts "#{jaaz[i].movie.title}"
  i +=1
  end

 puts  "PRESS ENTER TO RETURN TO MENU"

   p = gets.chomp

 end
#
#  User.where(name: "abdul").pluck(:id)
# D, [2019-03-28T15:34:32.766727 #5918] DEBUG -- :    (0.2ms)  SELECT "users"."id" FROM "users" WHERE "users"."name" = ?  [["name", "abdul"]]
# => [75]
# [28] pry(main)> User.where("name = 'abdul'").pluck(:id)
# D, [2019-03-28T15:35:14.548232 #5918] DEBUG -- :    (0.2ms)  SELECT "users"."id" FROM "users" WHERE (name = 'abdul')
# => [75]
# [29] pry(main)> User.where("name = \"abdul\"").pluck(:id)

########################MOVIES NOT WATCHED##############################################

def unwatchmovies(name)

  x = User.where(name: name).pluck(:id)

  puts x

  jaaz = Watchlist.where("user_id = #{x[0]} and watched = ?",false)

  #binding.pry

  i = 0
  while i < jaaz.length
  puts "#{jaaz[i].movie.title}"
  i +=1
  end

 puts  "PRESS ENTER TO RETURN TO MENU"

   p = gets.chomp

 end
################MOST WATCHED MOVIE#########################################


def mostwatchmovie()

 x = Watchlist.where("watched =?",true).pluck(:movie_id)

   hash = {}
   x.each do |keys|

   if hash.has_key? (keys)

       hash[keys] += 1

    else

      hash[keys] = 1

   end
   end

   puts hash

     x = hash.sort_by{|keys,values| -values}.first

     puts x

    puts Movie.where("id = #{x[0]}").pluck(:title)

  
end

def watchmovies(moviesname)
  #
    puts "you are going to watch movie"
  #
   Launchy.open("https://ww1.putlockerfree.sc/search-query/#{moviesname}/")
  #
  #
    end
  #
