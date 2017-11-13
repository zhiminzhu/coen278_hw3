#!/usr/bin/env ruby
require './students'
require './comments'

require 'sinatra'
require 'sinatra/reloader'
require 'data_mapper'
require 'slim'
require 'erb'

enable :sessions

$names_list = Array.new

$loginFlag = 0;

set :environment, :development


configure :development do
DataMapper.setup(:default, ENV["DATABASE_URL"] || "sqlite:students.db")
DataMapper.setup(:default, ENV["DATABASE_URL"] || "sqlite:comments.db")
end



configure :development, :text do
DataMapper.setup(:default, ENV["DATABASE_URL"] || "sqlite:students.db")
DataMapper.setup(:default, ENV["DATABASE_URL"] || "sqlite:comments.db")
end


configure :production do
  DataMapper.setup(:default, ENV["DATABASE_URL"] || "sqlite:students.db")
DataMapper.setup(:default, ENV["DATABASE_URL"] || "sqlite:comments.db")
end

configure do
  enable :session
  set :username, "yuan"
  set :password, "newnew"
end

get '/' do
    erb :home
end

get '/about' do
 erb :about
 %{<html>
        <body>
        <div style="text-align: center">
        <h1>Welcome to my page</h1>
        <img src="https://www.cleverfiles.com/howto/wp-content/uploads/2016/08/mini.jpg" width = 500/>
        <h1>New Minion</h1>
        </div>
        </body>
        </html>

    }
end

get '/contact' do
  erb :contact
end

get '/students' do
  if session[:admin] == true
    erb :students
  else
    redirect to '/login'
  end

end

get '/add' do
  erb :add
  
end

post '/add' do
  
  if(Students.get(params[:ID]) != nil)
    redirect '/students'
  else
  temp_students = Students.new
  temp_students.firstname = "#{params[:FirstName]}"
  temp_students.lastname = "#{params[:LastName]}"
  temp_students.birthday = "#{params[:Birthday]}"
  temp_students.address = "#{params[:Address]}"
  temp_students.student_id = "#{params[:ID]}"
  
  temp_students.save

  redirect '/students'
  end
end



post '/info' do
  erb :info
end

get'/edit' do
    erb :edit
end

post '/make' do
  Students.get($global_id).destroy

  if(Students.get(params[:newID]) != nil)
    redirect '/students'
  else
  temp_students = Students.new
  temp_students.firstname = "#{params[:newFirstName]}"
  temp_students.lastname = "#{params[:newLastName]}"
  temp_students.birthday = "#{params[:newBirthday]}"
  temp_students.address = "#{params[:newAddress]}"
  temp_students.student_id = "#{params[:newID]}"
  
  temp_students.save

  redirect '/students'
  end
end

post '/delete' do
    Students.get($global_id).destroy
    redirect '/students'
end

# --------Students--------to------here------

get '/comment' do
  erb :comment
end

get '/comments_add' do
    erb :comments_add
end

post '/comments_add' do

  temp_comments = Comments.new
  temp_comments.name = "#{params[:commentName]}"
  temp_comments.content = "#{params[:commentContent]}"
  temp_comments.student_id = "#{params[:commentId]}"
  
  temp_comments.save

  redirect '/comment'

end

post '/comments_info' do
  erb :comments_info
end

post '/comments_delete' do
  Comments.get($comments_global_id).destroy
  redirect '/comment'
end

# --------Comments--------to------here------

get '/video' do
  erb :video
end


# --------Video--------to------here------


get '/login' do
    erb :login
end

post '/login' do
    if params[:username] == settings.username && params[:password] == settings.password

      session[:admin] = true

      $loginFlag = 1;

      redirect to ('/students')
    else
      erb :login
  end
end

get '/logout' do
  session.clear
  redirect to ('/login')
end





get '/styles.css' do
  scss :styles
end

__END__
@@layout
<html>
<head> </head>
<body>
    <h1> Songs for Sinatra</h1>
    <img src="https://cdn.off---white.com/custom_page_images/1032/slider_1.jpg?1488806441" alt="Slider 1" width = 500>
    <div class="topnav" id="myTopnav">
      <a href="/">Home</a>
      <a href="/about">About</a>
      <a href="#contact">Contact</a>
      <a href="/students">Students</a>
      <a href="/comment">Comment</a>
      <a href="/video">Video</a>
      <% if session[:admin] == true %>
         <a href="/logout">Logout</a>
         <% else %>
      <a href="/login" id = "loginId">Login</a>
      <% end %>
    </div>
    <%= yield %>
</body>
</html>


@@home
<p> welcome</p>

@@about
<p> about the website</p>

@@contact
<p> contact me</p>




