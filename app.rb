	require "sinatra"
	require 'active_record'
	require 'sinatra/reloader'
	register Sinatra::Reloader
	require 'sinatra/base'

	ActiveRecord::Base.establish_connection(
		"adapter" => "sqlite3",
		"database" => "./score.db"
	)

	class Score < ActiveRecord::Base
	end

	get "/" do 
	    erb:index, :layout => false
	end

	get "/score_write" do
		erb:score_write
	end

	get "/score" do
		@scores = Score.order("id desc").all
		erb:score
	end

	post "/new" do 
		Score.create({  
			:id => params[:id],
			:school_name => params[:school_name],
			:semester => params[:semester],
			:japanese => params[:japanese],
			:english => params[:english],
			:math => params[:math],
			:science => params[:science],
			:social => params[:social],
			:test => params[:test]
			})
		redirect '/score_write'    
		erb :score_write
	end


	post "/check" do
		@semester = params[:semester]
		@test = params[:test]
		@school_name = params[:school_name]
		@japanese =  params[:japanese]
		@math =  params[:math]
		@english =  params[:english]
		@science =  params[:science]
		@social =  params[:social]
		erb:check
	end

	get "/score_write" do
		erb:score
	end
