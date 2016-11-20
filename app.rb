   # coding: UTF-8
   require 'sinatra'
   require 'active_record'
   require 'sinatra/reloader'
   register Sinatra::Reloader
   require 'sinatra/base'



   Encoding.default_external = 'UTF-8'

   enable :sessions

   ActiveRecord::Base.establish_connection(
   	"adapter" => "sqlite3",
   	"database" => "./score.db"
   	)

   class Score < ActiveRecord::Base
   end
   class User < ActiveRecord::Base
   end
	# coding: UTF-8

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
	

	get '/' do
		erb :index , :layout =>false
	end

	post '/login' do
		@user_name = params[:user_name]
		@user_pass = params[:user_pass]
		@user =  User.find_by(user_name: @user_name)
		if user = nil || @user_pass != @user.user_pass then
		else
			session[:user_id] = @user.user_id
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
		Score.create(
			user_id: session[:user_id].to_i,
			grade: params[:grade],
			semester: params[:semester],
			japanese:  params[:japanese],
			english:  params[:english],
			math: params[:math],
			science:  params[:science],
			social:  params[:social],
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
			erb :sign_up
		
	end

	post "/sign_up" do
			User.create(
				user_name: params[:user_name],
				user_pass: params[:user_pass],
				school_name: params[:school_name]
				)
			redirect "/login"
	end
	
 	
