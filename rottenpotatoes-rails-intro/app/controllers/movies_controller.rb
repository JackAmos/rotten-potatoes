class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #gets movice ratings from model
    @all_ratings = Movie.ratings

    #sets ratings and sort criteria based on selection or no selections
    session[:ratings] ||= @all_ratings
    session[:sort] ||= [:id]

    #when column is sorted, higlights column title
    if params[:sort] == 'title'
    
        @title_hilite = session[:title_hilite] = 'hilite'
        
    elsif params[:sort] == 'release_date'
    
        @date_hilite = session[:date_hilite] = 'hilite'
    end

    #gets any selected ratings
    if params[:ratings]
    
        session[:ratings] = params[:ratings].keys
    end
    
    #updates sort criteria
    if params[:sort]
        
        session[:sort] = params[:sort]
    end
    
    #if no sorting or ratings are done, makes all movies show up
    if  params[:ratings].nil? || params[:sort].nil?

        redirect_to movies_path(ratings: Hash[session[:ratings].map {|r| [r,1]}], sort: session[:sort])
    end

    #sets ratings and sort to selected values
    @ratings = session[:ratings]
    @sort = session[:sort]

    #displays movies based on selected criteria
    @movies = Movie.where(rating: @ratings).order(@sort)
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

end
