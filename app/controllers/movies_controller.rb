class MoviesController < ApplicationController

    def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
    end
  
    def index
      @movies = Movie.all
      if params[:sort_using]
        session[:sort_using] = params[:sort_using]
        sort_criteria = params[:sort_using]
      elsif session[:sort_using]
        sort_criteria = session[:sort_using]
      end    
      
      @all_ratings = Movie.all_ratings
      
      if(params[:ratings].nil?)
        if(session[:ratings_display].nil?)
          ratings = @all_ratings
        else
          ratings = JSON.parse(session[:ratings_display])
        end
      else
        ratings = params[:ratings].keys
      end
      
      @ratings_display = ratings
      
      if sort_criteria == "title" 
        @movies = Movie.with_ratings(ratings).order(:title)
      elsif sort_criteria == "release_date"
        @movies = Movie.with_ratings(ratings).order(:release_date)
      else
        @movies = Movie.with_ratings(ratings)
      end
      
      session[:ratings_display] = JSON.generate(ratings)
      session[:ratings] = params[:ratings]
      @sort_using = sort_criteria
    end
  
    def new
      # default: render 'new' template
    end
  
    def create
      @movie = Movie.create!(movie_params)
      flash[:notice] = "#{@movie.title} was successfully created."
      redirect_to movies_path
    end
  
    def edit
      @movie = Movie.find params[:id]
    end
  
    def update
      @movie = Movie.find params[:id]
      @movie.update_attributes!(movie_params)
      flash[:notice] = "#{@movie.title} was successfully updated."
      redirect_to movie_path(@movie)
    end
  
    def destroy
      @movie = Movie.find(params[:id])
      @movie.destroy
      flash[:notice] = "Movie '#{@movie.title}' deleted."
      redirect_to movies_path
    end
  
    private
    # Making "internal" methods private is not required, but is a common practice.
    # This helps make clear which methods respond to requests, and which ones do not.
    def movie_params
      params.require(:movie).permit(:title, :rating, :description, :release_date)
    end
  end