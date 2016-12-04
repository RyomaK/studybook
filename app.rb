   # coding: UTF-8
   require 'sinatra'
   require 'active_record'
   #require 'sinatra/reloader'
   #register Sinatra::Reloader
   require 'sinatra/base'
   require 'bcrypt'
   require 'cgi'



   Encoding.default_external = 'UTF-8'


  	configure do
    	# for ActiveRecord
    	ActiveRecord::Base.establish_connection(
   		"adapter" => "sqlite3",
   		"database" => "./score.db"
   		)
    	# for sessions
    	set :sessions, true
    	set :session_secret, 'My app secret abcde!!!'
    	set :environment, :production

    	# for inline_templates
    	set :inline_templates, true
 	 end

   class Score < ActiveRecord::Base
   end
   class User < ActiveRecord::Base
   	
   	validates :password_digest, presence: true
   	validates :user_name, uniqueness: true, presence: true, format: {with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i},length: {minimum: 2, maximum:  10}
   	validates :school_name, presence: true

 	 # for helper methods
 	 has_secure_password
 	end
	# coding: UTF-8
	helpers do

		def login?
			if session[:user_id] == nil then
				return false
			else
				return true
			end
		end

		def login_user
			User.find_by(user_id: session[:user_id])
		end


		def logout
			session.delete(:user_id)
		end

		def counter
			 file = File.new("data/access.txt", "r+")
			 file.flock(File::LOCK_EX)
			 cnt  = file.gets.to_i + 1 
			 file.seek(0, IO::SEEK_SET)
			 file.puts cnt
			 file.flock(File::LOCK_UN)
			 file.close
			 return cnt.to_s
		end

	end
	

	get '/' do
		erb :index , :layout =>false
	end

	post '/login' do

		user = User.find_by(user_name: params[:user_name])
		if user && user.authenticate(params[:user_pass]) then
			session[:user_id] = user.user_id
		else
		end

		if login? then
			redirect "/"
		else
			erb :miss_login
		end
	end

	get '/login' do
		erb :login
	end

	get '/logout' do
		logout
		erb :login
	end


	get "/score_write" do
		erb :score_write
	end

	get "/score" do
		@scores = Score.order("grade desc").all
		@users = User.find_by(user_id: session[:user_id])
		erb :score
	end

	post "/new" do 
		sum = params[:japanese].to_i+params[:english].to_i+params[:math].to_i+params[:science].to_i+params[:social].to_i
		Score.create(
			user_id: session[:user_id].to_i,
			grade: params[:grade],
			semester: params[:semester],
			japanese:  params[:japanese],
			english:  params[:english],
			math: params[:math],
			science:  params[:science],
			social:  params[:social],
			sum: sum,
			test:  params[:test]
			)
		redirect '/score_write'    
		erb :score_write
	end


	post "/check" do 
		@grade = params[:grade]
		@semester = params[:semester]
		@test = params[:test]
		@japanese =  params[:japanese]
		@math =  params[:math]
		@english =  params[:english]
		@science =  params[:science]
		@social =  params[:social]
		erb :check
	end

	get "/sign_up" do
		@notice = session[:notice]
		session[:notice] = nil
		erb :sign_up
	end

	post "/sign_up" do
		user = User.new do |u|
      		u.user_name = params[:user_name]
     		u.password = params[:user_pass]
    		u.password_confirmation = params[:pass_confirm]
    		u.school_name = params[:school_name]
    	end
  		if user.save && user.valid?
   			session[:user_id] = user.user_id
   			session[:notice]=nil
  			redirect "/" #user dashboard page
 		else
 			session[:notice] = "すでにユーザー名が使われているか、パスワードが合っていません"
    		redirect "/sign_up?"
  		end
	end

	post "/message" do

	end

	get "/rank" do
		@sc = Score.order("sum desc").all
		@us = User.order("user_id").all 
		erb :rank
	end

